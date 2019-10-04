#!/bin/bash
which pdftotext > /dev/null 2>&1
if [ $? != 0 ]; then
  echo " "
  echo "pdftotext has not been installed yet, run install_pdftotext.sh. Exiting"
  exit 0
fi

source ../lib/_functions.sh

DEBUG=false
VERBOSE=false
KO=false
BIO=false
KO_PARAMS=()
BIO_PARAMS=()
NAME="_name_"
ID_NUM="_id_num_"
REQUIRED_PARAMS=()

#TODO iterate over files in pdf_reports directory
echo "Converting pdf reports to txt format..."
rm ../txt_reports/*.txt >> /dev/null 2>&1
pdftotext -layout -eol unix -raw -enc UTF-8 ../pdf_reports/Suk.rtf.pdf ../txt_reports/Suk.rtf.txt

while (($#)); do
  case $1 in
    -h | --help)
      echo "help"
    ;;
    WBC|RBC|HGB|HCT)
      KO=true
      REQUIRED_PARAMS+=($1)
      KO_PARAMS+=($1)
    ;;
    Na|K|Cl)
      BIO=true
      REQUIRED_PARAMS+=($1)
      BIO_PARAMS+=($1)
    ;;
    -v|--verbose)
      VERBOSE=true
    ;;
    -d|--debug)
      DEBUG=true
    ;;
    *)
      echo "UNKNOWN PARAMETER, exiting."
      exit 1
    ;;
   esac
shift
done

report="Suk.rtf.txt"
path_to_txt_reports="../txt_reports"

#getting ID
NAME=$(head -10 ${path_to_txt_reports}/${report} | tail -1 | awk '{print $4" "$5}' | tr -d ',')
ID_NUM=$(head -11 ${path_to_txt_reports}/${report} | tail -1 | tr -d 'M')

#getting dates and times
if $KO ; then
  get_date "KO" "${path_to_txt_reports}/${report}" # returns arr DATES_KO
  get_times "KO" "${path_to_txt_reports}/${report}" # returns arr TIMES_KO
fi
if $BIO ; then
  get_date "BIO" "${path_to_txt_reports}/${report}" # returns arr DATES_BIO
  get_times "BIO" "${path_to_txt_reports}/${report}" # returns arr TIMES_BIO
fi

#parsing and getting values for required params
param=()
for param in "${REQUIRED_PARAMS[@]}"
do
  create_param_array ${param} "${path_to_txt_reports}/${report}"
done
#all values saved to arrays continue with csv
echo "Parsing and exporting to csv......"
rm ../csv_reports/*.csv > /dev/null 2>&1

#TODO name of files/path
 
#creating HEADER
HEADER="Prijmeni,jmeno,RC,datum,cas"
if $KO ; then
  for param in "${KO_PARAMS[@]}"
  do
    HEADER="$HEADER;$param"
  done
  verbose_print "$HEADER"
  echo $HEADER >> ../csv_reports/KO.csv
  for (( i=0; i<${#DATES_KO[@]};i++ ));
  do
    LINE="$NAME,$ID_NUM,${DATES_KO[$i]},${TIMES_KO[$i]}"
    for param in "${KO_PARAMS[@]}"
    do
      param="$param[@]"
      tmp_arr=("${!param}")
      LINE="$LINE,${tmp_arr[$i]}"
     done
    verbose_print "$LINE"
    echo $LINE >> ../csv_reports/KO.csv

  done
verbose_print "_______________________________"
fi

HEADER=""
HEADER="Prijmeni,jmeno,RC,datum,cas"
if $BIO ; then
 for param in "${BIO_PARAMS[@]}"
  do
    HEADER="$HEADER,$param"
  done
  verbose_print "$HEADER"
  echo $HEADER >> ../csv_reports/BIO.csv
  for (( i=0; i<${#DATES_BIO[@]};i++ ));
  do
    LINE="$NAME,$ID_NUM,${DATES_BIO[$i]},${TIMES_BIO[$i]}"
    for param in "${BIO_PARAMS[@]}"
    do
      param="$param[@]"
      tmp_arr=("${!param}")
      LINE="$LINE,${tmp_arr[$i]}"
     done
    verbose_print "$LINE"
    echo $LINE >> ../csv_reports/BIO.csv
  done
fi
echo ""
echo "Processing has been sucessfully finished. Generated files are to be found in csv_reports folder."
