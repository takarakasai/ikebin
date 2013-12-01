#! /bin/sh

TMP_DIR="./tmp"

check_symbl()
{
  TARGET_FILE=$1
  RES_ITSELF_FILE=$1"_res_itself.txt"
  RES_OTHERS_FILE=$1"_res_others.txt"
  SYMBOL_LIST=${TMP_DIR}"/symbol.list"

  echo "  TARGET:"${TARGET_FILE}

  grep  "^[a-z,A-Z].\+:$" ${TARGET_FILE} | awk -F":" '{ print $1 "," $2 }' > ${SYMBOL_LIST}

  TMP=${TMP_DIR}/tmp1.txt
  TMP2=${TMP_DIR}/tmp2.txt
  rm ${TMP} ${TMP2} ${RES_ITSELF_FILE} ${RES_OTHERS_FILE}

  for i in $(cat ${SYMBOL_LIST})
  do
    symbl=`echo $i | cut -d"," -f2`
    file=`echo $i | cut -d"," -f1`

    grep -n -w ${symbl} ${TARGET_FILE} | grep -v ${symbl}":" > ${TMP}
    awk -F"[:\t]" '{ print "   " $0 }' ${TMP} > ${TMP2}

    from_whole=`cat ${TMP2} | wc -l`
    from_self=`cat ${TMP2} | grep ${file} | wc -l`

    if [ "$from_whole" = "$from_self" ] ; then
      echo ${symbl} " at " ${file} >> ${RES_ITSELF_FILE}
      cat ${TMP2} >> ${RES_ITSELF_FILE}
    else
      echo ${symbl} " at " ${file} >> ${RES_OTHERS_FILE}
      cat ${TMP2} >> ${RES_OTHERS_FILE}
    fi
  done

  echo "-- called only by itself-------------------------------------------------"
  cat ${RES_ITSELF_FILE}
  echo ""
  echo "-- called also by others-------------------------------------------------"
  cat ${RES_OTHERS_FILE}
  echo ""
  echo ""
}

check_symbl "as1*.s"
check_symbl "as2*.s"


