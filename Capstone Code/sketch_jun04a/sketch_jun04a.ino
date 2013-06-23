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


//info defining single guesture
struct action {
   int * high;
   int * low;
   char* name;
};

//LLNode for action
struct actionNode {
   struct action * action;
   struct actionNode  *next;
};

struct actionNode * peter; 

int b1=7;//mux digital pin #1
int b0=8;//mux digital pin #2
int* p;//recognize() data
int readings[10];//data from sensors
int * dims;//ordered list of dimentions
int * crosses;//ordered list of crosses in given dimension
int holding;
int * mctrs;
int ** mat1;
int ** mat2;
char buffer[30];
int  bufctr=0;
//@inputs action that was just added and weight to be given to it(mostly -1/1)
//finds the number of crosses created by a specific action adds them to crosses
//and sorts dims based on crosses
void dimShift(struct actionNode * ptr,int weight)
{
	struct actionNode *head=peter;
  	int i,j,m,minat,temp;
	if(dims==NULL)
	{
		dims=(int*)malloc(sizeof(int)*10);
		for(i=0;i<10;i++)
		{
			dims[i]=i;
		}
		crosses=(int*)calloc(10,sizeof(int));

	}
	while(head!=NULL)
	{
		if(head==ptr)
		{
			head=head->next;
			continue;
		}
		for(i=0;i<10;i++)
		{
			if((head->action->high[dims[i]]<ptr->action->low[dims[i]])||(head->action->low[dims[i]]>ptr->action->high[dims[i]]))
			{
				crosses[i]=crosses[i]+weight;
			}
		}
		head=head->next;
	}
	for(i=0;i<10;i++)
	{
		m=crosses[i];
		minat=i;
		for(j=(i+1);j<10;j++)
		{
			if(m>crosses[j])
			{
				m=crosses[j];
				minat=j;
			}
		}
		temp=dims[i];
		dims[i]=minat;
		dims[minat]=temp;
		crosses[minat]=crosses[i];
		crosses[i]=m;
	}
}

//@inputs starting ptr and current guesture
//@output name of action if it exists NULL otherwise
//checks the created actions for one that matches the given guesture
int isAction(struct actionNode *ptr, int a[10])
{
	int i,j;
	int outside;
        struct actionNode *ptr2=ptr;//for priority
        int h=0;
        //while there are still things in the LL
	while(ptr!=NULL)
	{
		outside=0;
		for(i=0;i<10;i++)//for each dimention
		{
			j=dims[i];
                 //check to see if the guesture matches the current action in the current dimention     
			if((ptr->action->high[j]<a[j])||(ptr->action->low[j]>a[j]))
			{
                                //if it is mark guesture wrong and move on
				outside=1;
				break;
			}
		}
                //if guesture is never marked wrong
		if(!outside)
		{
                        //do action (light up light for now)
                        //if chosen action is not already in first
                        int xx;
                        if (bufctr==19){
                          for (xx=0; xx<19; xx++){
                            buffer[xx]=buffer[xx+1];
                          }
                          buffer[19]=*ptr->action->name;
                        }
                        else {
                          buffer[bufctr]=*ptr->action->name;
                          bufctr++;
                        }
                        for (int i=0; i<50; i++)
                        {
                          Serial.println("\n");
                        }
                        for (xx=0; xx<20; xx++){
                          Serial.print(buffer[xx]);
                        }
                        Serial.print("\n");
                        
                        //Serial.println(*ptr->action->name);
                        holding=1;
                        
                        if(ptr2!=ptr)
                        {
                          //switch the chosen 
                          struct action *temp=ptr->action;
                          ptr->action=ptr2->action;
                          ptr2->action=temp;
                        }
			return *ptr2->action->name;
                    
                        
		}
                ptr2=ptr;
		ptr=ptr->next;
	}
	return NULL;
}

/*
  @inputs LL node, 11 data points, name of gesture
  @outputs returns a pointer witht the new action
  adds a new action 
*/

struct actionNode * addAction(struct actionNode * ptr, int a[10], char name)
{
	struct actionNode * rtn=ptr;
	struct actionNode * ptr2;
	int i;
	holding=1;
	//while pointer has data in it, update it
	while(ptr!=NULL)
	{
		//checks if the name of the action is the same
		if(*ptr->action->name==name)
		{
  
			dimShift(ptr,-1);
		  // goes through and sets the new max and min values
		  for(i=0;i<10;i++)
		  {

		  	ptr->action->low[i]=min(ptr->action->low[i],a[i]-10);
			ptr->action->high[i]=max(ptr->action->high[i],a[i]+10);


		  }
			dimShift(ptr,1);
		  return rtn;
		}
		ptr2=ptr;
		ptr=ptr->next;
	}
	// if there is no data instantiate the highs and lows  
	ptr=(struct actionNode *)malloc(sizeof(struct actionNode *));
	ptr->action=(struct action *)malloc(sizeof(struct action *));
	ptr->next=NULL;
	ptr->action->high=(int*)malloc(12*sizeof(int));
        ptr->action->high=ptr->action->high+1;
	ptr->action->low=(int*)malloc(11*sizeof(int));
	for(i=0;i<11;i++)
	{
		ptr->action->low[i]=a[i]-10;
		ptr->action->high[i]=a[i]+10;	
	}
        ptr->action->name=(char*)malloc(sizeof(char));
	*ptr->action->name=name;
	if(rtn==NULL)
	{
		rtn=ptr;
	}
	else
	{
		ptr2->next=ptr;	
	}
	dimShift(ptr,1);
	return rtn;
}

//Determines when the user's hands have been still for a long time
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
          //Serial.println("bing!");
          holding=0;
        }
      }
    }
    if(tog==0&&holding==0){
      isAction(peter,array);
    }
    (ctrs[1])=((ctrs[1])+1)%10;
  }
}


void removeAction(char name) {
	struct actionNode * point = peter;
	struct actionNode * point2;
        if(*point->action->name==name)
        {
           peter=point->next;
            free(point->action->high-1);
            free(point->action->low);
           free(point->action);
          free(point);
       return; 
        }
	while(point->next != NULL) {
		if (*point->next->action->name == name)
		{
			point2 = point;
			point->next = point2->next->next;
			free(point2->action->high);
			free(point2->action);
			free(point2);
			return;
		}
		point = point->next;
	}


}


void setup() {
  mat1=(int**)malloc(10*sizeof(int*));
  int ctr;
  for (ctr=0; ctr<10; ctr++){
    mat1[ctr]=(int*)calloc(10, sizeof(int));
  }
  buffer[0]='X';
  mat2=(int**)malloc(10*sizeof(int*));
  for (ctr=0; ctr<10; ctr++){
    mat2[ctr]=(int*)calloc(10, sizeof(int));
  }
  mctrs=(int*)calloc(2, sizeof(int));
  p=(int*)malloc(10*sizeof(int));
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
  holding=0;
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
  
  //Serial.println("!\n");

  
  if(Serial.available ()) {
    
    char ch = Serial.read();
    
    if ((ch >='a') && (ch<='z')) {
      peter=addAction(peter, readings, ch);
      int i;
      for(i=0;i<10;i++)
      {
        Serial.println(peter->action->high[i]);
      }
    }
    else if (ch=='=') {
      for (int i=0; i<50; i++)
      {
        Serial.println("\n");
      }
      int j;
      bufctr=0;
      for(j=0; j<20; j++){
        buffer[j]=' ';
      }
    }
    else if((ch >='A') && (ch<='Z')) {
      ch = ch + 32;
      removeAction(ch);
    }
    else if(ch==' '){
      peter=addAction(peter, readings, ch);
      int i;
      for(i=0;i<10;i++)
      {
        Serial.println(peter->action->high[i]);
      }
    }
    
  }
  
  recognize_b(readings, mat1, mat2, mctrs);
}

