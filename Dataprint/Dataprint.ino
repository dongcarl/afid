#include <stdio.h>
#include <stdlib.h> 
#include <string.h>



#ifndef max
  #define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

#ifndef min
  #define min( a, b ) ( ((a) < (b)) ? (a) : (b) )
#endif
#ifndef nullchk
	#define nullchk(a) ((a==NULL) ? "NULL" : (a) )
#endif



int b1=7;//mux digital pin #1
int b0=8;//mux digital pin #2
int readings[10];//data from sensors
int * mctrs;
int ** mat1;
int ** mat2;

void recognize_b(int *array, int **avgmat1, int **avgmat2, int *ctrs)
{
  int m;
  for (m=0; m<10; m++){
    avgmat1[ctrs[0]][m]=array[m];
  }
  (ctrs[0])=((ctrs[0])+1)%10;
  int x, y;
  if (ctrs[0]==0) {
    int avg[10];
    int j, k, sum;
    for (j=0; j<10; j++){
      sum=0;
      for (k=0; k<10; k++){
        sum+=avgmat1[k][j];
      }
      avg[j]=sum/10;
    }   
    int tog=0;
    int last=((ctrs[1]+1)%10);
    
    for (m=0; m<10; m++){
      avgmat2[(ctrs[1])][m]=avg[m];
      if((avgmat2[(ctrs[1])][m]-avgmat2[last][m])>15){
        tog=1;
        if((avgmat2[(ctrs[1])][m]-avgmat2[last][m])>25){
        }
      }
    }
    int ind;
    if(tog==0){
         for (ind=0; ind<10; ind++){
           Serial.print(array[ind]);
           Serial.print("  ");
         }
         Serial.print("\n"); 
    }
    (ctrs[1])=((ctrs[1])+1)%10;
  }    
}

void setup() {
  mat1=(int**)malloc(10*sizeof(int*));
  int ctr;
  for (ctr=0; ctr<10; ctr++){
    mat1[ctr]=(int*)calloc(10, sizeof(int));
  }
  mat2=(int**)malloc(10*sizeof(int*));
  for (ctr=0; ctr<10; ctr++){
    mat2[ctr]=(int*)calloc(10, sizeof(int));
  }
  mctrs=(int*)calloc(2, sizeof(int));
  Serial.begin(9600);
  pinMode(6, INPUT);
  pinMode(7, OUTPUT);
  pinMode(11, 'output');
  pinMode(12, 'output');
  pinMode(10, 'output');
  pinMode(b1, 'output');
  pinMode(b0, 'output');
  digitalWrite(11,LOW);
  digitalWrite(10,LOW);
  digitalWrite(12,LOW);
  pinMode(b1, 'output');
  pinMode(b0, 'output');
  
  delay(1000);
  Serial.flush();
}


void loop() {
    
  digitalWrite(b1, LOW);
  digitalWrite(b0, LOW);
  readings[0]=analogRead(0);
  readings[1]=analogRead(2);
  readings[2]=analogRead(3);
  readings[3]=analogRead(4);
  
  digitalWrite(b0, HIGH);
  readings[4]=analogRead(0);
  readings[5]=analogRead(2);
  readings[6]=analogRead(3);
  readings[7]=analogRead(4);
  
  digitalWrite(b1, HIGH);
  digitalWrite(b0, LOW);
  readings[8]=analogRead(0);
  readings[9]=analogRead(2);
  
  
  
  recognize_b(readings, mat1, mat2, mctrs);
}

