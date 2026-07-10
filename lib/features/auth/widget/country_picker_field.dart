import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';

class CountryPickerField extends StatelessWidget {
  const CountryPickerField({
    super.key,
    required this.countryName,
    required this.onChanged,
  });

  final String countryName;
  final void Function({required String dialCode, required String countryName})
  onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: CountryCodePicker(
        onChanged: (countryCode) {
          final dialCode = countryCode.dialCode;
          if (dialCode == null) return;
          onChanged(
            dialCode: dialCode,
            countryName: countryCode.name ?? countryName,
          );
        },
        initialSelection: 'GB',
        showDropDownButton: false,
        showFlag: false,
        showCountryOnly: true,
        showOnlyCountryWhenClosed: true,
        alignLeft: true,
        dialogTextStyle: context.textTheme.bodyMedium,
        dialogBackgroundColor: context.colorScheme.surface,
        padding: EdgeInsets.zero,
        builder: (countryCode) {
          final flagUri = countryCode?.flagUri;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                if (flagUri != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: Image.asset(
                      flagUri,
                      package: 'country_code_picker',
                      width: 34.w,
                      height: 24.h,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Icon(
                    Icons.flag_rounded,
                    color: const Color(0xFF64748B),
                    size: 24.r,
                  ),
                14.horizontalSpace,
                Expanded(
                  child: Text(
                    countryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF64748B),
                  size: 26.r,
                ),
              ],
            ),
          );
        },
        searchDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF64748B),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
