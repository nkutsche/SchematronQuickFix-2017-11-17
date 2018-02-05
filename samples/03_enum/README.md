| [Back](../02_datatype/README.md) | [Up](../README.md) | [Next](../04_copy-of/README.md) |

# Enumerations For Code Value Lists 

This example shows, that generic types as described in the example [02_datatype](../02_datatype/README.md) do not match to all use cases. User defined code lists contain often generic text, but only specific values are valid. Our example here is a list of known and allowed units: 

- `ml`
- `mg`
- `g`
- `cl`
- `tbl`

For this cases usually for GUIs a dropdown list will be used to be able to select correct values only. To trigger such a dropdown list the Escali Plugin uses a trick. If a UserEntry has a sequence as default value the plugin creates a dropdown list. Each value of the sequence will be used as one item of this list.
