#!/usr/bin/awk -f

BEGIN {
    FS="@@@";
    split(cols, colsArray, ",")
}
{
    for (i = 1; i <= NF; i++) {
        if (i == 1) {
            printf "{";
        }

        if (i == NF) {
            printf "\"%s\": \"%s\" ", colsArray[i], $i;
            printf "}\n";
        }
        else {
            printf "\"%s\": \"%s\", ", colsArray[i], $i;
        }
    }
}
