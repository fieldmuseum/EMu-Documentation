# Exporting EMu data while SSHed into the server
This document explains commands that assist with exporting data from EMu,
so you can import the data into a more web usable/searchable database.
e.g. MongoDB, PostreSQL, MySQL, Solr, etc.

Larry Gall from Yale Peabody was kind enough to provide additional information on how
the `texexport` command works. That info is saved in this
[Word Doc](Texpress/Using-texql-and-texexport-to-export-data-from-EMu.docx).

Before we start, please note that these instructions assume you have root command line
access to the EMu server, to be able to export the data. Your IT department or provider
must provide you with access in order to export your data in this way. Ultimately, you
need to be able to switch to the `emu` user on the server in order to run these commands.

## Texpress reference documents
* [Texpress Client-Server API Guide](Texpress/Texpress-Client-Server-API-Guide.docx)
* [Texpress User Guide](Texpress/Texpress-User-Guide.docx)
* [Texpress Texql](Texpress/Texpress-Texql.docx)

## Using command line tools on the EMu server to extract data
To start, be sure to be logged in as the `emu` user after you've SSHed into the server.

`$ su - emu`

## EMu module column names
Before we start, if you have any confusion as to the actual column names for an EMu module, you can use the
describe command as you would with most RDMS.

First, invoke the `texql` command with no parameters.

Now, describe your EMu module.
`texql 1> describe emultimedia;`

And you will see something like this:
```
emultimedia[
    irn(
        irn_1      integer
    ),
    MulTitle   text,
    DetSubject_tab[
        DetSubject text
    ],
    DetSource  text,
    DetDate0[
        DetDate    date
    ],
    DetRights  text,
```
...

## Querying data using texql and texexport
Next, you can use the texql command, with a here string, to query the EMu database and output that data
into a text file. Here is an example query that returns all of the IRNs for Botany.

`texql <<< "select irn.irn_1 from ecatalogue where CatDepartment = 'Botany';" | sed 's/[()]//g' > botany_irns.txt`

We're using `sed` to remove the parenthesis from the output so they can be used in the next step. This command
will output the Botany IRNs, putting a single IRN on a line.

If you would like to take a quick look at our output, you can invoke the `tail` command to view the end of the
file to see how it's formatted.

`$ tail -n10 botany_irns.txt`

Now that we have all of the IRNs of the records we want to query, we're going to use the `texexport` command to
query all of the data for each record. This is an example `texexport` command to output data for the
Botany records from the first step. We will need to setup a shell script; you can take a look at our
[sample shell script](emu-export-examples/botany_export.sh). Make sure the ownership of the shell script is
emu:emuadmin and make sure it's executable.

Here are the contents of that file.

```
while read irn; do
    texexport -fidsbrief -l"$irn" ecatalogue >> botany_records.txt
done < botany_irns.txt
```

This is a very simple shell script that run the `texexport` command for each line of our `botany_irns.txt` file
and appends the results to the `botany_records.txt` file. You'll see it looking something like this.

```
rownum=1
irn:1=154014
SummaryData:1=Lycopersicon pennellii (Correll) D'Arcy, Peru, A. Sagástegui A. 15290, F
ExtendedData:1=154014
ExtendedData:2=
ExtendedData:3=Lycopersicon pennellii (Correll) D'Arcy, Peru, A. Sagástegui A. 15290, F
CatMuseum:1=Field Museum of Natural History
CatDepartment:1=Botany
CatCatalog:1=Botany
CatCatalogSubset:1=Seed Plants
CatProject:1=Andean Flowering Plants
CatControlNumber:1=DILL-12609
ObjKindOfObject:1=Dried specimen
ObjObjectNumber:1=2138512
ObjRepositoryRef:1=64
ObjRepositoryRefLocal:1=64
ObjRepositoryLocal:1=F
ObjCollectionArea:1=Searle herbarium
...
###
```

Note that the three pound signs indicate the end of a record. You can also look for the rownum field to
indicate the start of a new record.

The main benefit of using the `-fidsbrief` export is that we will get every single non-empty field for each
record, with key:value pairs for the data. There will be no ambiguity about the fields you need to parse.
You also *do not* need to specify the fields you want to export. This is a huge win.

You'll notice that fields have a :1, :2, etc. behind their name to indicate multi-value fields, for fields
that have values more than :1. This will help when you need to parse the text for importing into your database.

Last thing, while the `texexport` command doesn't have man pages, you can invoke the command `texexport` without
any parameters to get a general idea of the purpose of each flag.

## TODO/WIP -- Processing the text output
We didn't discuss transforming the exported text file into a proper format for insertion into
your database, along with strategies to do so. Once FMNH gets our workflow in place, I will add our
process to this document. Our current workflow involves using IMu --> Solr but if this process is
faster and more efficient, we will likely start using texsql, texexport and a custom import script
as a replacement for IMu.
