#!/bin/bash
which pdftotext > /dev/null 2>&1
if [ $? != 0 ]; then
  echo " "
  echo "pdftotext has not been installed yet, run install_pdftotext.sh. Exiting"
  exit 0
fi

source ../lib/get_date.func

VERBOSE=false
KO=false
BIO=false
KO_params=()
BIO_params=()
NAME="_name_"
ID_NUM="_id_num_"

#TODO iterate over files in pdf_reports directory
echo "Converting pdf reports to txt format..."
pdftotext -layout -eol unix -raw -enc UTF-8 ../pdf_reports/Suk.rtf.pdf ../txt_reports/Suk.rtf.txt

while (($#)); do
  case $1 in
    -h | --help)
      echo "help"
    ;;
    WBC|RBC|HGB|HCT)
      KO=true
      KO_params+=($1)
    ;;
    Na|K|CI)
      BIO=true
      BIO_params+=($1)
    ;;
    -v|--verbose)
      VERBOSE=true
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
echo $NAME
echo $ID_NUM

if $KO ; then
  #date of medical procedure
  get_date "KO" "${path_to_txt_reports}/${report}" # returns arr DATES_KO
  get_times "KO" "${path_to_txt_reports}/${report}" # returns arr TIMES_KO
fi
if $BIO ; then
  get_date "BIO" "${path_to_txt_reports}/${report}" # returns arr DATES_BIO
  get_times "BIO" "${path_to_txt_reports}/${report}" # returns arr TIMES_BIO
fi
