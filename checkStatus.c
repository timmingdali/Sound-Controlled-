#include <stdio.h>
int check_y(int x,int y){
	int i;
	int count=0;

	for(i=0;i<3;i++){
		
		volatile short *vga_addr=(volatile short*)(0x08000000 + ((y+28)<<10) + ((x+i+3)<<1));
		int colour = *vga_addr;
		if(colour == -1){}
		else if(colour == 0){
			count ++;
		}
		else 
			return 3;
		vga_addr=(volatile short*)(0x08000000 + ((y+28)<<10) + ((x+i+12)<<1));
		colour = *vga_addr;
		if(colour == -1){}
		else if(colour == 0){
			count ++;
		}
		else 
			return 3;

	}

	for(i=0;i<5;i++){
		volatile short *vga_addr=(volatile short*)(0x08000000 + ((y+13+i)<<10) + ((x+20)<<1));
		int colour = *vga_addr;
		if(colour == -1){}
		else if(colour == 0){
		}
		else 
			return 3;

	}
	
	
	for(i=0;i<4;i++){
		volatile short *vga_addr=(volatile short*)(0x08000000 + ((y-3)<<10) + ((x+5+i)<<1));
		int colour = *vga_addr;
		if(colour == -1){}
		else if(colour == 0){
		}
		else 
			return 3;
	}

	/*
	
	volatile short *vga_addr2=(volatile short*)(0x08000000 + ((y-1)<<10) + ((x+15)<<1));
	int colour2 = *vga_addr2;
	if(colour2 != -1 && colour2 != 0){
		
			return 3;
		}
		
		volatile short *vga_addr3=(volatile short*)(0x08000000 + ((y+37)<<10) + ((x+36)<<1));
	int colour3 = *vga_addr3;
	if(colour3 != -1 && colour3 != 0){
		
			return 3;
		}
	*/
		//printf ("\n");
		if(count>=3)
			return 1;
		else return 0;
	
}