# am_searchable_dropdown 🎯

A highly customizable and **feature-rich searchable dropdown** for Flutter. It supports **single-select**, **multi-select with checkboxes**, and works seamlessly with any generic data model `<T>`.

Designed for developers who need full control over the UI while keeping the implementation simple and clean.

---

## ✨ Features

*   🔍 **Powerful Search**: Instant local filtering or server-side (remote) search callbacks.
*   🎯 **Single & Multi Select**: Support for both single item selection and multiple items with checkboxes.
*   🏗️ **Generic Type Support `<T>`**: Use it with Strings, Integers, or your own complex Data Models.
*   🎨 **Full UI Customization**: Provide your own builders for the **Header** and **List Items**.
*   🛡️ **Form Validation**: Integrated with Flutter's `FormField` for easy validation and error handling.
*   ⚡ **Performance Optimized**: Built-in debouncing (500ms) for smooth search, especially with remote APIs.
*   📱 **Safe Overlay Handling**: Intelligent positioning to avoid being cut off by screen edges or the keyboard.

---

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  am_searchable_dropdown: ^1.0.2
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start (Basic Usage)

For simple lists like strings, you can get started in seconds:

```dart
CustomSearchDropdownWidget<String>(
  itemsList: ["Apple", "Banana", "Cherry", "Date"],
  backgroundColor: Colors.white,
  selectedItem: _selectedFruit,
  onChange: (value) => setState(() => _selectedFruit = value),
  headerBuilder: (context, selectedItem, enabled) => Text(selectedItem ?? "Select Fruit"),
  listItemBuilder: (context, item, isSelected) => Text(item),
)
```

---

## 🎯 Advanced Example (Real-World Models)

Most apps use models. `am_searchable_dropdown` makes this easy by allowing you to work directly with your objects.

```dart
CustomMultiSearchDropdownWidget<User>(
  itemsList: _users, // List<User>
  selectedItems: _selectedUsers, // List<User>
  backgroundColor: Colors.white,
  onChanged: (values) => setState(() => _selectedUsers = values),
  // Transform your model to a searchable string
  itemToString: (user) => user.name, 
  headerBuilder: (context, selectedItems, enabled) {
    return Text(
      selectedItems.isEmpty 
        ? "Select Users" 
        : selectedItems.map((e) => e.name).join(", "),
    );
  },
  listItemBuilder: (context, user, isSelected) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: isSelected ? Icon(Icons.check_circle, color: Colors.blue) : null,
    );
  },
)
```

---

## 🌟 Feature Breakdown

### 1. Custom Model Support
Use `itemToString` to define how your complex objects should be searched. No need to override `toString()` in your class (though you still can!).

```dart
itemToString: (item) => item.fullName,
```

### 2. Header Customization
The "Header" is the button that opens the dropdown. You have 100% control over its design using `headerBuilder`.

```dart
headerBuilder: (context, selectedItem, enabled) {
  return Container(
    padding: EdgeInsets.all(12),
    border: Border.all(color: Colors.blue),
    child: Text(selectedItem?.name ?? "Pick a User"),
  );
},
```

### 3. List Item UI
Style the items inside the dropdown exactly how you want. You get access to `isSelected` to highlight the current choice.

```dart
listItemBuilder: (context, item, isSelected) {
  return Container(
    color: isSelected ? Colors.blue.withOpacity(0.1) : null,
    child: Text(item.name),
  );
},
```

### 4. Search Field Customization
Tweak the appearance of the search input field to match your app's theme.

```dart
searchFieldDecoration: InputDecoration(
  hintText: "Search customers...",
  prefixIcon: Icon(Icons.person_search),
  border: OutlineInputBorder(),
),
```

### 5. Form Validation & Error UI
Built-in support for `validator`. You can customize the error text style and border.

```dart
validator: (value) => value == null ? "Please select an item" : null,
errorTextStyle: TextStyle(color: Colors.red, fontSize: 13),
errorBorder: Border.all(color: Colors.red, width: 2),
```

### 6. Multi Select with Checkboxes
`CustomMultiSearchDropdownWidget` provides a familiar multi-select interface with checkboxes integrated into the logic.

---

## 💡 Best Practices

1.  **Unique Types**: Ensure your generic type `<T>` implements `==` and `hashCode` correctly if using complex objects.
2.  **Debounced Search**: If using `onSearch` for remote APIs, remember that the package already debounces for 500ms to save your backend from too many requests.
3.  **Background Color**: Match the `backgroundColor` of the dropdown panel to your app's theme for a seamless experience.

---

## 🔗 Links

*   **GitHub**: [Abdul520Mannan/searchable_dropdown](https://github.com/Abdul520Mannan/searchable_dropdown)
*   **Issue Tracker**: [Report a Bug](https://github.com/Abdul520Mannan/searchable_dropdown/issues)

---

Developed with ❤️ by [Abdul Mannan](https://github.com/Abdul520Mannan)
