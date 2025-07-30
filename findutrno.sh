#!/bin/bash

echo "Please select directory search: if extracted press 1, if archive press 2"
echo "Enter  1  Search Directory ,file already  extracted, /home/archiving_user/SVNODE1/home_smartfe_output_arch_logs/tmp"
echo "Enter  2  Archive Directory located /home/archiving_user/SVNODE1/home_smartfe_output_arch_logs    Extract Directory located /home/archiving_user/SVNODE1/home_smartfe_output_arch_logs/tmp "

read choice

case $choice in
    1)
        directory_search="/home/archiving_user/SVNODE1/home_smartfe_output_arch_logs/tmp"

        echo "Please Enter UTRNO number through a space to search directory in $directory_search"
        read -a Utrnno_Array

        now_date=$(date +'%Y%m%d_%H%M')
        mkdir "/home/archiving_user/Script/FoundUtrnnoDir/Dir_$now_date"

        for elem in "${Utrnno_Array[@]}"
        do
            find "$directory_search" -type f -exec grep -rl "$elem" {} \; >> "/home/archiving_user/Script/FoundUtrnnoDir/Dir_$now_date/found_files_$elem.txt"
            tar -czvf "/home/archiving_user/SVNODE1/home_smartfe_output_arch_logs/tmp/output_outfiles_$elem.tar.gz" -C "$directory_search" --files-from="/home/archiving_user/Script/FoundUtrnnoDir/Dir_$now_date/found_files_$elem.txt"
        done
       #rm -r "/home/archiving_user/Script/FoundUtrnnoDir/Dir_*"
        ;;
    2)
        directory_search="/home/archiving_user/SVNODE1/home_smartfe_output_arch_logs"

        echo "Search directory in /home/archiving_user/Script/output_arch_logs_extract"
        echo "Enter transaction date (plus one day) YearMonthDay EXAMPLE FORMAT 20231221"
        read transaction_date

        echo "Please Enter UTRNO number through a space to search directory in $directory_search"
        read -a Utrnno_Array

        now_date=$(date +'%Y%m%d_%H%M')
        mkdir "/home/archiving_user/Script/FoundUtrnnoDir/Dir_$now_date"

        find "$directory_search" -name "*$transaction_date*" -exec tar -xzvf {} -C "/home/archiving_user/SVNODE1/home_smartfe_output_arch_logs/tmp" \;

        for elem in "${Utrnno_Array[@]}"
        do
            find "/home/archiving_user/SVNODE1/home_smartfe_output_arch_logs/tmp" -type f -exec grep -rl "$elem" {} \; >> "/home/archiving_user/Script/FoundUtrnnoDir/Dir_$now_date/found_files_$elem.txt"
            tar -czvf "/home/archiving_user/SVNODE1/home_smartfe_output_arch_logs/tmp/output_arch_logs_extract_$elem.tar.gz" -C "/home/archiving_user/SVNODE1/home_smartfe_output_arch_logs/tmp" --files-from="/home/archiving_user/Script/FoundUtrnnoDir/Dir_$now_date/found_files_$elem.txt"
        done
        #rm -r "/home/archiving_user/Script/FoundUtrnnoDir/Dir_*"
        ;;
    *)
        echo "You must enter number 1 or 2"
        ;;
esac
