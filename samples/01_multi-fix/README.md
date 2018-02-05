| [Back](../00_schematron/README.md) | [Up](../README.md) | [Next](../02_datatype/README.md) |
|--|--|--|

# Call Multiple QuickFixes by One Action

This sample file contains multiple violations of different but also of the same kind. The medications.xml contains three medictions. Two IDs do not match to its `name`, each `name` contains not allowed whitespace and neither one `created` nor one `valid-to` element cotains a valid date in the format `xs:date`. 

To fix all Schematron errors the execution of eleven QuickFixes would be necessary. In native Oxygen this would require eleven actions and the user has to wait always until the QuickFix is executed and a new validation process is finished.

With the Escali Plugin the user is able to select multiple QuickFixes by once and execute them. For this, the user selects a Schematron error in the view *Escali Schematron*. The view *Escali QuickFixes* lists now each available QuickFix which can be selected by a radio button. If a selected QuickFix has an UserEntry, the user is now able to define the value in the view *Escali UserEntries*.

Back to the view *Escali Schematron* the button *Execute all QuickFixes* can be used to execute all selected QuickFixes by once.

Additionally the toolbar of *Escali Schematron* view provides the actions to select similar QuickFixes of other Schematron erros when one QuickFix was already selected (buttons *Select identical fixes* and *Select identicl fixes (from identical tests)*).

Also both views, *Escali Schematron* and *Escali QuickFixes*, provides actions to select the default QuickFix.

