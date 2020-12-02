# Query and return CT Scan multimedia IRNs
texql <<< "select irn.irn_1 from emultimedia where exists (DetSubject_tab where DetSubject contains 'CT scan');" | sed 's/[()]//g' > irns.txt
