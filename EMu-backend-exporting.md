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

### Verifying EMu module column names
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

### Querying data using texql and texexport
Next, you can use the texql command, with a here string, to query the EMu database and output that data
into a text file. Here is an example query that returns all of the IRNs for Botany.

`texql <<< "select irn.irn_1 from ecatalogue where CatDepartment = 'Botany';" | sed 's/[()]//g' > botany_irns.txt`

We're using `sed` to remove the parenthesis from the output so they can be used in the next step. This command
will output the Botany IRNs, putting a single IRN on a line.

If you would like to take a quick look at our output, you can invoke the `tail` command to view the end of the
file to see how it's formatted.

`$ tail -n10 botany_irns.txt`

Now that we have all of the IRNs of the records we want to query, we're going to use the `texexport` command to
query all of the needed data for each record. Here is an example `texexport` command to output data for the
Botany records from the first step. Please note that this is outputting one record per line in a delimited
format.

`texexport -fdelimited -kbotany_irns.txt -md -ms"@@@" -cirn,SummaryData ecatalogue > botany_records.txt`

The `-f` format flag tells the command that we want the output in delimited format.

The `-k` flag specifies a text file that contains rows of keys (IRNs) that we'll be using for the query.

We can also specify our delimiter with the `-ms` flag. You should specify something *unique*, that won't
be reoccuring in your dataset. Underscores and pipes are probably a bad idea to use, at the Field Museum
pipe delimiters are often used in summary strings, making it a bad choice for a delimiter. We're using
`@@@` 3 cherries in this example. Pick something that works for you, even non-visible characters works.
Here's a
[discussion](https://stackoverflow.com/questions/6319551/whats-the-best-separator-delimiter-characters-for-a-plaintext-db-file)
on this topic.

If you take a look at the `-c` flag, you'll also see we're only exported two fields per record.
You will likely want to add more fields to this flag. List out the fields you want to export in a
comma-delimited fashion.

Last, of course we'll need to specify what EMu module we're querying and where to put the output.

While the `texexport` command doesn't have man pages, you can invoke the command `texexport` without any
parameters to get a general idea of the purpose of each flag.

### Examples
Please see these examples of commands to run to query and export data.

* [Botany export](emu-export-examples/botany.sh)
* [Multimedia CT Scan export](emu-export-examples/ct-scans.sh)
