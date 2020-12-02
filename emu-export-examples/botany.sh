# Query and return all Botany IRNs
texql <<< "select irn.irn_1 from ecatalogue where CatDepartment = 'Botany';" | sed 's/[()]//g' > botany_irns.txt

# Output record data to text file
texexport -fdelimited -kbotany_irns.txt -md -ms"@@@" -cirn,SummaryData ecatalogue > botany_records.txt
