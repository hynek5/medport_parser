#!/bin/bash
#################################################
# Function: verbose_print 
# Inputs : $1 - msg to be printed
#################################################
verbose_print () {
  if $VERBOSE; then
    echo "VERBOSE: $*"
  fi
}
#################################################
# Function: debug_print 
# Inputs : $1 - msg to be printed
#################################################
debug_print () {
  if $DEBUG; then
    echo "DEBUG: $*"
  fi
}

#################################################
# Function: get_date
# Inputs : $1 - type of medical lab check-up
#          $2 - full relative path to pdf report
# Outputs: DATES - array of dates
#################################################
get_date () {
  if  [ "$1" == "KO" ]; then
    DATES_KO=()
    DATES_KO=($(grep "$1 " $2 | awk '{print $2}' | awk -F '-' '{print $1}'))
    debug_print "function get_date(): DATES_KO are ${DATES_KO[@]}"
  else 
    DATES_BIO=()
    DATES_BIO=($(grep "$1 " $2 | awk '{print $2}' | awk -F '-' '{print $1}'))
    debug_print "function get_date(): DATES_BIO are ${DATES_BIO[@]}"
   fi
}

#################################################
# Function: get_times
# Inputs : $1 - type of medical lab check-up
#          $2 - full relative path to pdf report
# Outputs: DATES - array of dates
#################################################
get_times () {
  if [ "$1" == "KO" ]; then
    TIMES_KO=()
    TIMES_KO=($(grep "$1 " $2 | awk '{print $2}' | awk -F '-' '{gsub(/:$/,"",$2); print $2}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' | cut -c 2-))
    debug_print "function get_times(): TIMES_KO are ${TIMES_KO[@]}"
  else 
    TIMES_BIO=()
    TIMES_BIO=($(grep "$1 " $2 | awk '{print $2}' | awk -F '-' '{gsub(/:$/,"",$2); print $2}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' | cut -c 2-))
    debug_print "function get_times(): TIMES_BIO are ${TIMES_BIO[@]}"
 fi
}
#################################################
# Function: get_param_values
# Inputs : $1 - medical parameter
#          $2 - full relative path to pdf report
# Outputs: array containing values
#################################################
get_param_values () {
  grep "$1:" $2 | sed 's/: /:/g' | sed "s/.*$1\(.*\) .*/\1/" | cut -c 2- | awk '{print $1}'
}

#################################################
# Function: create_param_array
# Inputs : $1 - param
#          $2 - full relative path to pdf report
# Outputs: array of parameters values
#################################################
create_param_array () {
  path=$2
   case $1 in
     WBC)
       WBC=($(get_param_values $1 $2))
       debug_print WBC ${WBC[@]} 
     ;;
     RBC)
       RBC=($(get_param_values $1 $2))
       debug_print RBC ${RBC[@]} 
     ;;
     HGB)
       HGB=($(get_param_values $1 $2))
       debug_print HGB ${HGB[@]} 
     ;;
     HCT)
       HCT=($(get_param_values $1 $2))
       debug_print HCT ${HCT[@]} 
     ;;
     K)
       K=($(get_param_values $1 $2))
       debug_print K ${K[@]} 
     ;;
     Na)
       Na=($(get_param_values $1 $2))
       debug_print Na ${Na[@]} 
     ;;
    Cl)
       Cl=($(get_param_values $1 $2))
       debug_print Cl ${Cl[@]} 
     ;;




esac  
}
  

