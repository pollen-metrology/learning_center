#!/bin/bash
#$BACKUP_FILES=($(find . -type f -name "backup_2020-03*"))
#backup_2020-04-19-03.00.01.zip
MONTH_DAY=`date +"%d"`
WEEK_DAY=`date +"%u"`
BACKUP_FILES=( $(find backup -type f -name "backup_*" | sort) )
# loop array
for i in ${BACKUP_FILES[@]}
  do
    fileName=$i
    tag=""
    # /backup_2019-11-20-03.00.01.zip
    # Keep first day of the year
    if [[ $fileName == *"backup_"*"-01-01-"*"."*"."*".zip" ]]; then
      tag="KEEP"
    else
      # Keep first day of the mount
      if [[ $fileName == *"backup_"*"-"*"-01-"*"."*"."*".zip" ]]; then	
        tag="KEEP"
      else
	# Keep 14 older days
        OLDER_DAYS=( $(find backup/ -type f -mtime -14) )
        if [[ ${OLDER_DAYS[*]} == *"$fileName"* ]]; then
	  tag="KEEP"
        else
	  tag="DEL"     	
        fi	  
      fi	      

#      # Keep first day of the mount
#      else if [[ $fileName == *"backup_"*"-"*"-01-"*"."*"."*".zip" ]]; then
#        tag="KEEP"	
#	# Keep 14 older days
#	OLDER_DAYS=( $(find backup/ -type f -mtime -14) )
#	echo "TEST "$fileName
#        else if [[ ${OLDER_DAYS[*]} == *"$fileName"* ]]; then
#	  #echo "TEST : "$fileName	
#          tag="KEEP"
#	  else
#            tag="DEL END"
#        fi	  
#      fi	
    fi
    output=$fileName" ========================> "$tag 
    echo $output
      # Delete backup
      if [[ $tag == "DEL" ]]; then
        echo "DELETE "$fileName
	rm $fileName
      fi	
  done	  
