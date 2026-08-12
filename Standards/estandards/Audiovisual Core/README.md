## FMNH AC estandards

XML reports include:

1. [**AC_Media_StandardRecord.xml**](AC_Media_StandardRecord.xml)
    - One estandard record where type = "Standard" and name = "Audiovisual Core"

2. [**AC_Media_TermDefRecords.xml**](AC_Media_TermDefRecords.xml)
    - All "Term Definition" records attached to the "Audiovisual Core" Standard record.


The [Extension Entries CSV](registry_ExtensionEntries.csv) includes eregistry entries for:

1. **Standard Extension**
    - allows Audiovisual Core to be used as an Extension in an EMu Catalogue Standard Export of Darwin Core records.
    - 'MulMultiMediaRef_tab' is specified as the attachment field.

2. **Extension Repeater**
    - Defines 'dwc:occurrenceID' as the 'repeater' or attachment term from an DwC occurrence (ecatalogue) record to its AC media (emultimedia) record/s.
