| [Back](../04_copy-of/README.md) | [Up](../README.md) | [Next](../06_process-order/README.md) |

# Schematron Extension to Set the Context by Regular Expressions

Schematron has usually a limitation that it is only possible to match on (text) nodes and not on substrings of nodes. However, Schematron will be used to identify correct spelling of some words quite often. Mostly it is hard to the user to identify the misspelled words in long paragraphs. 

In addition, there is always be only one QuickFix per error message, so it is only able to fix all misspelled words inside of a paragraph by once.

The Escali provides now a Schematron extension to support also error matching on substrings. The syntax and the implementation rules [was desribed here](http://www.schematron-quickfix.com/escali/escali-ext_en.html#sqf:d121e932).

The Escali Plugin provides now a first draft implementation for QuickFixes for this extension. The implementation works as it was planned when the es:regex extension was designed: Each Activity Element, which matches on the current context (`match="."` or no match attribute) matches in fact on the substring, which is the context of the error.

Additionally to this, the current implementation provides a help variable $es:match for access to the context substring inside of the Activity Element.
