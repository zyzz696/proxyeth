#!/bin/bash

python $1 2>&1 | awk '

        BEGIN {
                sum=0
                w=0
                rej=0
        }

        {
                col="\033[0;0m"
        }

        /eth_submitWork/&&/protocol/{
                nl+=1
                w+=1
                sum=0
                if (nl>15) nl=0
                if ($0 ~ /REJECT/) {
                        arr[nl]=1
                        rej+=1
                        col="\033[31m"
                } else {
                        arr[nl]=0
                        col="\033[32m"
                }

                for (i in arr) sum+=arr[i]
                if (arr[13]=="") col="\033[33m"
                        else if (sum*100/length(arr)>'30') system("pkill -f '$1'")
        }

        {
                CONVFMT="%.2f"
                if (w=="0") st="na"
                        else st=rej*100/w
                printf "%-8s %-8s %-6s | %s\033[0;0m\n", "A:"w, "R:" st "%", "WD:" sum, col $0
        }'