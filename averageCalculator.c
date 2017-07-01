#include <stdio.h>
#define Level0 5000000
#define Level1 8000000
#define Level2 11000000
#define Level3 15000000



int averageCalculator (int* f) {


	long long int sum = 0;
	
	for (int i = 0; i < 4795; i++){
		
		sum = sum + f[i];
		
		
	}


	sum = sum / 4800;
	
	//printf ("%d\n", sum);
	
	if (sum <= Level0 ){
		return 0;
	}else if (sum > Level0 && sum <= Level1){
		return 1;
	}else if (sum > Level1 && sum <= Level2){
		return 2;
	}else if (sum > Level2 && sum <= Level3){
		return 3;
	}else if (sum > Level3){
		return 4;
	}
		


}