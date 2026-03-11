## 1.1.0

*   Refactored `CustomSearchDropdownWidget` and `CustomMultiSearchDropdownWidget`:
    *   Removed `topContext` parameter.
    *   Added `itemToString` parameter for custom search filtering.
    *   Ensured safe internal copy of `itemsList`.
    *   Added safe overlay removal checks (`overlay.mounted`).
*   Updated repository URL to `https://github.com/Abdul520Mannan/searchable_dropdown`.

## 1.0.0

* Initial release.
* Added `CustomSearchDropdownWidget` for single selection.
* Added `CustomMultiSearchDropdownWidget` for multiple selection with checkboxes.
* Added `CustomRadioSearchDropdownWidget` for single selection with radio buttons.
* Implemented conditional local search: local filtering only occurs if `onSearch` is null.
* Used `item.toString()` for local matching.
