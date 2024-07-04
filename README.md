# constype

# For Start
- seed db once with `make seedDb` 
- run app with `make launch`

# Lua Naming Conventions

### Variables and Functions:
- Use lowercase letters.
- Separate words with underscores for readability.
- Example: my_variable, calculate_sum.

### Constants:
- Use uppercase letters.
- Separate words with underscores.
- Example: MAX_VALUE, DEFAULT_SIZE.

### Tables (Objects):
- Use camelCase or PascalCase (start with an uppercase letter if it is a module or a class-like table).
- Example: myTable, MyClass.

### Modules:
- Use PascalCase.
- Example: MathUtils, StringHelper.

### Local Variables:
- Use shorter names if the scope is small and the context is clear.
- Example: i, count.

### Function Parameters:
- Use descriptive names for clarity.
- Example: function calculate_area(width, height).

### Metatables and Metamethods:
- Prefix with __ to signify their special role.
- Example: __index, __newindex.

