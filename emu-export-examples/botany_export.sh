while read irn; do
    texexport -fidsbrief -l"$irn" ecatalogue >> botany_records.txt
done < botany_irns.txt
