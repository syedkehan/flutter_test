import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/config/theme/app_text_styles.dart';

/// Horizontal alignment for a column (header + cells).
enum TableViewColumnAlign { start, center, end }

/// One cell in an [AppTableView] row: plain text ([AppTableCellText]) or any [Widget].
sealed class AppTableCell {
  const AppTableCell();
}

final class AppTableCellText extends AppTableCell {
  const AppTableCellText(this.text);
  final String text;
}

final class AppTableCellCustom extends AppTableCell {
  const AppTableCellCustom({required this.child});
  final Widget child;
}

extension AppTableCellsFromStrings on List<List<String>> {
  List<List<AppTableCell>> toAppTableCells() =>
      map((row) => row.map(AppTableCellText.new).toList()).toList();
}

/// One column definition: title, flex weight, and text alignment.
class TableViewColumn {
  const TableViewColumn({
    required this.label,
    this.flex = 1,
    this.alignment = TableViewColumnAlign.center,
  });

  final String label;
  final int flex;
  final TableViewColumnAlign alignment;
}

/// A rounded table view with a colored header row and data rows separated by thin dividers.
///
/// [rows] can be any length. Each row must have the same number of cells as [columns].
/// Text cells use [rowTextStyle]; use [AppTableCellCustom] for buttons or other widgets.
/// Default styling uses a purple header; override [headerBackgroundColor] as needed.
class AppTableView extends StatelessWidget {
  const AppTableView({
    super.key,
    required this.columns,
    required this.rows,
    this.headerBackgroundColor = const Color(0xFF6221D9),
    this.headerTextStyle,
    this.rowTextStyle,
    this.rowBackgroundColor = Colors.white,
    this.dividerColor = const Color(0xFFE8E8E8),
    this.cornerRadius,
    this.cellVerticalPadding,
    this.cellHorizontalPadding,
    this.bottomPadding,
    this.isLoadingMore = false,
  }) : assert(columns.length > 0);

  final List<TableViewColumn> columns;
  final List<List<AppTableCell>> rows;

  final Color headerBackgroundColor;
  final TextStyle? headerTextStyle;
  final TextStyle? rowTextStyle;
  final Color rowBackgroundColor;
  final Color dividerColor;

  /// Outer clip radius; defaults to [14.r].
  final double? cornerRadius;

  final double? cellVerticalPadding;
  final double? cellHorizontalPadding;
  final double? bottomPadding;
  final bool isLoadingMore;

  static Color get defaultRowTextColor => const Color(0xFF5A6274);

  /// Bottom padding under the scrollable rows.
  static double get nestedScrollBottomPadding => 44.h;

  @override
  Widget build(BuildContext context) {
    final radius = cornerRadius ?? 16.r;
    final vPad = cellVerticalPadding ?? 14.h;
    final hPad = cellHorizontalPadding ?? 14.w;
    final resolvedBottomPadding = bottomPadding ?? 0;

    final resolvedHeaderStyle =
        headerTextStyle ?? AppTextStyles.w500_16.copyWith(color: Colors.white);
    final resolvedRowStyle =
        rowTextStyle ??
        AppTextStyles.w400_12.copyWith(
          color: defaultRowTextColor,
          fontFamily: urbanist,
        );

    final header = _HeaderRow(
      columns: columns,
      backgroundColor: headerBackgroundColor,
      textStyle: resolvedHeaderStyle,
      verticalPadding: vPad,
      horizontalPadding: hPad,
    );

    final rowList = ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, thickness: 1, color: dividerColor),
            _DataRow(
              row: rows[i],
              columns: columns,
              textStyle: resolvedRowStyle,
              backgroundColor: rowBackgroundColor,
              verticalPadding: vPad,
              horizontalPadding: hPad,
            ),
          ],
          if (isLoadingMore) ...[
            Divider(height: 1, thickness: 1, color: dividerColor),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final table = constraints.hasBoundedHeight
            ? Column(
                children: [
                  header,
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: resolvedBottomPadding),
                      child: rowList,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  header,
                  rowList,
                  if (resolvedBottomPadding > 0)
                    SizedBox(height: resolvedBottomPadding),
                ],
              );

        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: table,
        );
      },
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.columns,
    required this.backgroundColor,
    required this.textStyle,
    required this.verticalPadding,
    required this.horizontalPadding,
  });

  final List<TableViewColumn> columns;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Row(
        children: [
          for (var c = 0; c < columns.length; c++)
            Expanded(
              flex: columns[c].flex,
              child: _alignedHeaderCell(columns[c], textStyle),
            ),
        ],
      ),
    );
  }
}

Widget _alignedHeaderCell(TableViewColumn col, TextStyle style) {
  final text = Text(col.label, style: style);
  switch (col.alignment) {
    case TableViewColumnAlign.start:
      return Align(alignment: Alignment.centerLeft, child: text);
    case TableViewColumnAlign.center:
      return Center(child: text);
    case TableViewColumnAlign.end:
      return Align(alignment: Alignment.centerRight, child: text);
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.row,
    required this.columns,
    required this.textStyle,
    required this.backgroundColor,
    required this.verticalPadding,
    required this.horizontalPadding,
  });

  final List<AppTableCell> row;
  final List<TableViewColumn> columns;
  final TextStyle textStyle;
  final Color backgroundColor;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    assert(
      row.length == columns.length,
      'Each row must have ${columns.length} cells; got ${row.length}.',
    );

    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Row(
          children: [
            for (var c = 0; c < columns.length; c++)
              Expanded(
                flex: columns[c].flex,
                child: _alignedDataCell(
                  row[c],
                  columns[c].alignment,
                  textStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _alignedDataCell(
  AppTableCell cell,
  TableViewColumnAlign alignment,
  TextStyle textStyle,
) {
  switch (cell) {
    case AppTableCellText(:final text):
      return _alignedTextDataCell(text, alignment, textStyle);
    case AppTableCellCustom(:final child):
      return _alignedWidgetCell(child, alignment);
  }
}

Widget _alignedTextDataCell(
  String value,
  TableViewColumnAlign alignment,
  TextStyle style,
) {
  final text = Text(value, style: style, textAlign: _textAlignFor(alignment));

  switch (alignment) {
    case TableViewColumnAlign.start:
      return Align(alignment: Alignment.centerLeft, child: text);
    case TableViewColumnAlign.center:
      return Center(child: text);
    case TableViewColumnAlign.end:
      return Align(alignment: Alignment.centerRight, child: text);
  }
}

Widget _alignedWidgetCell(Widget child, TableViewColumnAlign alignment) {
  switch (alignment) {
    case TableViewColumnAlign.start:
      return Align(alignment: Alignment.centerLeft, child: child);
    case TableViewColumnAlign.center:
      return Center(child: child);
    case TableViewColumnAlign.end:
      return Align(alignment: Alignment.centerRight, child: child);
  }
}

TextAlign _textAlignFor(TableViewColumnAlign a) {
  switch (a) {
    case TableViewColumnAlign.start:
      return TextAlign.left;
    case TableViewColumnAlign.center:
      return TextAlign.center;
    case TableViewColumnAlign.end:
      return TextAlign.right;
  }
}
