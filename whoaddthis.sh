TARGET_ANO_FILE=target_ano_file
CHANGES_ANO_FILE=changes_ano_file
TAG=`cat CVS/Tag|tr 'T' ' '`
echo $TAG
RET=`cvs annotate -r $TAG $FILE_NAME > $TARGET_ANO_FILE`
if [ $? -ne 0 ]
then
	echo "Sorry failed to get annotate file
	executed this command: cvs annotate -r $TAG $FILE_NAME > $TARGET_ANO_FILE"
fi

USER_NAME=`sed '900!d' $TARGET_ANO_FILE |awk '{print( $2  )}'|tr '(' ' '`
#DATE=`sed '900!d' $TRAGET_ANO_FILE |awk '{print( $3  )}'|tr '):' ' '`

echo $USER_NAME
echo $DATE


