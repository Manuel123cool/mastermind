#!/bin/bash

echo Enter \"h\" for help.

declare -a all_patterns
declare -a all_hints

declare -a random_num
	
for value in {1..4} 
do
	random_num[$value]=$(( $RANDOM % 8 + 1 ))
done

counter=0

while [ $counter -le 8 ] 
do
	read -p 'Enter pattern: ' pattern_gusst
	right_pattern=$( printf $pattern_gusst | egrep '^[1-8],[1-8],[1-8],[1-8]' )
	
	random_pattern="${random_num[1]},${random_num[2]},${random_num[3]},${random_num[4]}"

       	while [ -z $right_pattern ]
	do
		read -p 'Enter pattern: ' pattern_gusst
 		right_pattern=$( printf $pattern_gusst | egrep '^[1-8],[1-8],[1-8],[1-8]' )

		if [ $pattern_gusst = 'o' ]
                then
                        count=0
                        while [ $count -lt $counter ]
                        do
                                echo "${all_patterns[$count]}  ${all_hints[$count]}"
                                (( count++ ))
                        done
                elif [ $pattern_gusst = 'r' ]
                then
                        echo $random_pattern
                elif [ $pattern_gusst = 'h' ]
                then
                        echo There are eight numbers. And a random pattern of four numbers,
                        echo that you dont know. Your mission is to find that pattern.
                        echo When you enter your numbers you have to sperate them with
                        echo a comma. When you enter \"o\" you get an overview of your
                        echo last gussts and hints, in order. By entering \"r\" you get
                        echo the random pattern and a note how you should enter your gusst.
			echo After the beginning or after every printed hint you have have
			echo to enter a radom character before you can enter you letters,
			echo like \"o\".
                fi
	done
	
	if [ $random_pattern = $pattern_gusst ]
	then
		echo You won!
		break
	fi

	all_patterns[$counter]="$pattern_gusst"

	declare -a gusst_num

	for value in {1..4}
	do
		gusst_num[$value]=$( printf $pattern_gusst | cut -f $value -d ',' )
	done
	
	
	declare -a num_in_pattern
	declare -a num_right_place
	
	for value in {1..8}
	do
		num_in_pattern[$value]=0
		num_right_place[$value]=0
	done

	for value in {1..4}
	do
		if [ ${random_num[$value]} -eq ${gusst_num[$value]} ]
		then
			number="${random_num[$value]}"
			(( num_right_place[$number]++ ))
		fi
	done
	
	for value in {1..4}
	do
		number="${gusst_num[$value]}" 
		if [ "${num_right_place[$number]}" -ge 1 ]
		then
			continue
		elif [ "${num_in_pattern[$number]}" -eq 1 ]
		then
			continue
		fi

		for value2 in {1..4}
		do
			if [ ${gusst_num[$value]} -eq ${random_num[$value2]} ]
			then
				number="${gusst_num[$value]}"
				num_in_pattern[$number]=1
			fi
		done
	done

	overall_in_pattern=0
	overall_right_place=0

	for value in "${num_right_place[@]}"
	do
		if [ $value -ge 1 ]
		then
			overall_right_place=$(( $value + $overall_right_place ))
		fi
	done

	for value in "${num_in_pattern[@]}"
	do
		if [ $value -eq 1 ]
                then
               		 (( overall_in_pattern++ ))
                fi
	done

	all_hints[$counter]="in the pattern: $overall_in_pattern ,in the right place: $overall_right_place" 
	echo ${all_hints[$counter]}


	(( counter++ ))
done

echo Done!
