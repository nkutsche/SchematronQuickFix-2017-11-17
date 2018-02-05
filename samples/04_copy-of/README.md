| [Back](../03_enum/README.md) | [Up](../README.md) | [Next](../05_microtypo/README.md) |

# Copy code not a node

This feature will be part of the next public version of the SQF specification. It will introduce a new `sqf:copy-of` element. Basically it should act as an `xsl:copy-of` element, so it also provides a `select` attribute which selects node to be copied.

Copying nodes means always to copy on the DOM view which leads to the case, that all entities inside of the copied nodes will be resolved, all descendent implicit attributes (defined by a default value in a DTD) will be written out, etc.. 

To avoid such unwanted changes the `sqf:copy-of` element provides addionally a `unparsed-mode` attribute. If this is set by the value `true` the copy process should copy the code and not the node. All the described changes abouve should not happen.

The Escali Plugin provides a first draft of an implementation of this unparsed mode.
