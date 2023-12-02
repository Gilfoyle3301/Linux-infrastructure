#!/bin/bash

for ip in $(cat /tmp/access.log | awk '{print $1}' | uniq -c | sort -nr | head -n5 | awk '{print $2}')
do
    grep "$ip" /tmp/access.log >> /tmp/sort.log

done

# Send a mail to given email
SUBJECT="CRON INFO $(date +"%d/%m/%Y")"
# # This is a temp file, which is created to store the email message.
MESSAGE="/tmp/new-cron-logs.txt"
TO=""

echo  "ip addres: $(cat /tmp/access.log | awk '{print $1}' | uniq -c | sort -nr | head -n5)" >> $MESSAGE
echo -e "\n" >> $MESSAGE
echo "+------------------------------+" >> $MESSAGE
echo "The site:" >> $MESSAGE
grep -oP "https*://([a-zA-Z]*){2,4}.(ru|com)/" /tmp/sort.log | uniq -c >> $MESSAGE
echo "+------------------------------+" >> $MESSAGE
echo "Who/Code/protocols:" >> $MESSAGE
awk '{print "method:"$6"\t""protocol:"$8"\t""code:"$9"\t""where:"$7}' /tmp/sort.log | sort -k4 | uniq -c | sort -rn >> $MESSAGE
echo "+------------------------------+" >> $MESSAGE
echo "ERRORS:" >> $MESSAGE
grep "$(date +"%H"):" /tmp/error.log >> $MESSAGE
mail -s "$SUBJECT" "$TO" < $MESSAGE
rm -f $MESSAGE