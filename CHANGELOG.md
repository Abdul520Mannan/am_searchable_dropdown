## 1.0.3

*   **Enabled / Disabled State**: Added `isEnabled` property to toggle user interaction with the dropdown.
*   **Disabled UI Customization**: Introduced `disabledHeaderDecoration` to style the dropdown when it's deactivated.
*   **Default Disabled Style**: Added a sensible default light grey background for the disabled state.
*   **Visual Enhancements**: Opacity for suffix icon automatically adjusts when dropdown is disabled.

## 1.0.2

*   **Form Validation Support**: Wrapped dropdown headers in `FormField` to support `validator` and `autovalidateMode`.
*   **New Styling Properties**: Added `headerDecoration`, `headerPadding`, `suffixIcon`, `errorTextStyle`, and `errorBorder`.
*   **State Synchronization**: Implemented post-frame callback to keep `FormField` value in sync with selected items.
*   **Visual Feedback**: Added support for showing validation error text and applying error borders when validation fails.
*   **Documentation Upgrade**: Comprehensive `README.md` update with advanced usage examples and feature breakdown.

## 1.0.1

*   Improved pub.dev score by adding comprehensive API documentation (dartdoc comments).
*   Updated repository URLs to match the package name for better pub.dev verification.

## 1.0.0

*   Initial release.
*   **Project Rename**: Fixed misspelling from `searable_dropdown` to `searchable_dropdown`.
*   Added `CustomSearchDropdownWidget` for single selection.
*   Added `CustomMultiSearchDropdownWidget` for multiple selection with checkboxes.
*   Added `CustomRadioSearchDropdownWidget` for single selection with radio buttons (deprecated/removed in latest but noted in history).
*   **Refactor & Safety**:
    *   Removed `topContext` parameter requirement.
    *   Added `itemToString` parameter for custom search filtering.
    *   Implemented safe internal `itemsList` copying.
    *   Added `overlay.mounted` checks for safe disposal.
*   Implemented conditional local search (if `onSearch` is null).
*   Generic Type Support `<T>` for all widgets.
*   Added debounced search input (500ms).
*   Repository: `https://github.com/Abdul520Mannan/searchable_dropdown`.
