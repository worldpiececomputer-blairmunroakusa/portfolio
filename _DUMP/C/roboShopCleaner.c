//==================================================================================================================//
//==================================================================================================================//
//            robot_system.c version 1.2, Blair Munro, 2015                  //
//==================================================================================================================//
//==================================================================================================================//

/*
This program simulates a garbage collecting 'robot' and a person moving around in a workshop.
The workshop is messy, so the robot was programmed to move around and collect trash (objects scattered about) without crashing into people.
The robot takes a random walk, avoiding walls and the person.
Program ends when robot picked up all the garbage.
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

FILE * fileExcel;

struct data_items{
	float x,y,z;
	float move_directionX, move_directionY,moveSpeed;
	float radius;
	int collide;
	int available;
	int stopped;
	int person_collide;
}object[12];
// OBJECT [10:robot, 11:person]

int robotID, personID, placeholder=11, personpoints=0, filenumber=1;
int totalObjects, totalAgent, totalPoints=(int)0;
float workshop_sizeX,workshop_sizeY,zero;



//==================================================================================================================//
//==================================================================================================================//
void workshop_API(void);
void moving_around(void);

void robot_moving_around(void);
void robot_change_direction(void);
void avoid_person(struct data_items *p1);
void remove_object_found(struct data_items *p1);

void person_moving_around(void);
void person_change_direction(struct data_items *p1);

void generate_direction(struct data_items *p1);
void calculate_position(struct data_items *p1);
void avoid_wall(struct data_items *p1);
int detectCollision(struct data_items *p1, struct data_items *p2);

int objectsToCollect(void);
void init_position(void);
void init_variables(int currentObj);
void generate_starting_position(int currentObj);
int uniform_distribution_ranges(int rangeLow, int rangeHigh);
//==================================================================================================================//
//==================================================================================================================//
void workshop_API(void){

	srand((unsigned)time(NULL));

	init_position();

	moving_around();
}
//==================================================================================================================//
//==================================================================================================================//
void moving_around(void){
	int running=1,work_to_do=totalObjects,i;

	while(work_to_do>0){
		printf("walking around (%d)\n",running);

		work_to_do=objectsToCollect();

		person_moving_around();
		robot_moving_around();

		for(i=0;i<totalObjects;i++){
			printf("%d",object[i].available);
		}
		printf("roboX %0.2f, roboY %0.2f\n",object[robotID].x,object[robotID].y);

		running++;
	}
}
//==================================================================================================================//
//==================================================================================================================//
void robot_moving_around(void){
	int currentObj;

	robot_change_direction();

	for(currentObj=0;currentObj<totalObjects;currentObj++){

		if(   detectCollision(&object[robotID],&object[currentObj])
		   && object[currentObj].available							){

			remove_object_found(&object[currentObj]);
			printf("Collected Object #%d of %d: +1 point\n",currentObj,totalObjects);
			printf("Total Points: %d person points: %d\n",totalPoints, personpoints);
		}
	}
}
//==================================================================================================================//
//==================================================================================================================//
void robot_change_direction(void){

	generate_direction(&object[robotID]);

	calculate_position(&object[robotID]);

	avoid_person(&object[robotID]);

	avoid_wall(&object[robotID]);

}
//==================================================================================================================//
//==================================================================================================================//
void avoid_person(struct data_items *p1){
	int same_direction;
	float temp_directionX,temp_directionY;

	if(detectCollision(&object[robotID],&object[personID])){

		temp_directionX=object[robotID].move_directionX;
		temp_directionY=object[robotID].move_directionY;

		do{

			generate_direction(p1);

			if((p1->move_directionX == temp_directionX) &&
					(p1->move_directionY == temp_directionY)){
				same_direction=1;
			}else{
				same_direction=0;
			}

		}while(same_direction);

		calculate_position(p1);
	}
}
//==================================================================================================================//
//==================================================================================================================//
void remove_object_found(struct data_items *p1){
	int objfor;
	char objnumber[5];
	char filename[20]={"ROBOSIM"};
	char extension[5]={".xls"};

	p1->available=0;
	totalPoints+=10;

	sprintf(objnumber,"%d",filenumber);
	strcat(filename,objnumber);
	strcat(filename,extension);

	fileExcel=fopen(filename,"w");
	if (fileExcel == 0){
		printf("File error occured");
		exit(1);
	}


	for(objfor=0;objfor<=personID;objfor++){

		fprintf(fileExcel,"%f\t%f\t%d\n",object[objfor].x,object[objfor].y,object[objfor].available);
	}

	filenumber++;

	fclose(fileExcel);
}
//==================================================================================================================//
//==================================================================================================================//
void person_change_direction(struct data_items *p1){

	generate_direction(&object[personID]);

	p1->moveSpeed=(float)uniform_distribution_ranges(zero,(int)object[robotID].moveSpeed);

	calculate_position(&object[personID]);

	avoid_wall(&object[personID]);

}
//==================================================================================================================//
//==================================================================================================================//

void person_moving_around(void){
	int currentObj;

	person_change_direction(&object[personID]);

	for(currentObj=0;currentObj<totalObjects;currentObj++){

		if(   detectCollision(&object[personID],&object[currentObj])
		   && object[currentObj].available
		   && placeholder!=currentObj				){

			object[placeholder].person_collide=0;
			totalPoints-=4;
			placeholder=currentObj;
			object[currentObj].person_collide=1;
			printf("Collided with Object #%d of %d: -4 point\n",currentObj,totalObjects);
			printf("Total Points: %d\n",totalPoints);

			personpoints+=4;
		}
	}
}

//==================================================================================================================//
//==================================================================================================================//
void generate_direction(struct data_items *p1){
	int moving;
	do{

		p1->move_directionX=(float)uniform_distribution_ranges(zero,2)-1;
		p1->move_directionY=(float)uniform_distribution_ranges(zero,2)-1;

		moving=p1->move_directionX+p1->move_directionY;
		if(moving==0){ // the same as if(moving==0)
			p1->stopped=1;
		}else{
			p1->stopped=0;
		}
	}while(p1->stopped);
}
//==================================================================================================================//
//==================================================================================================================//
void calculate_position(struct data_items *p1){

	p1->x += p1->moveSpeed * p1->move_directionX;

	p1->y += p1->moveSpeed * p1->move_directionY;
}
//==================================================================================================================//
//==================================================================================================================//
void avoid_wall(struct data_items *p1){

	if(p1->x > workshop_sizeX){
		p1->x = workshop_sizeX;
	}

	if(p1->x < 0){
		p1->x = 0;
	}

	if(p1->y > workshop_sizeY){
		p1->y = workshop_sizeY;
	}

	if(p1->y < 0){
		p1->y = 0;
	}
}
//==================================================================================================================//
//==================================================================================================================//
int detectCollision(struct data_items *p1, struct data_items *p2){
	float distance;

	distance = sqrt(( (p1->x - p2->x) * (p1->x - p2->x) )
			         + ((p1->y - p2->y) * (p1->y - p2->y)));

	if (distance <= (p2->radius + p1->radius)){
		// collision detect
		puts("collision DETECTED");
		p1->collide=1;
	}else{
		p1->collide=0;
	}
	return(p1->collide);
}
//==================================================================================================================//
//==================================================================================================================//
void init_position(void){
	int currentObj,previousObj, notfirst;
	robotID=0,personID=1;

	workshop_sizeX=(float)50;
	workshop_sizeY=(float)50;
	zero=(float)0;

	// for 10 objects, the objects is the 9th;
	totalObjects=(int)10;
	// the robot is the 10 and person 11; total vector struct 12;
	robotID=totalObjects, personID=(int)totalObjects+1;
	totalAgent=(int)2;

	for(currentObj=0;currentObj<(totalObjects+totalAgent);currentObj++){
		notfirst=currentObj;

		init_variables(currentObj);

		// generate the initial position for objects
		generate_starting_position(currentObj);

		if(notfirst){ // zero false, true otherwise for any value different than zero
			// CHECK IF THE OBJECT IS IN SAME POSITION OF PREVIOUS OBJECTS
			for(previousObj=(currentObj-1);previousObj>0;previousObj--){
				object[currentObj].collide=detectCollision(&object[currentObj],
						&object[previousObj]);
				if(object[currentObj].collide){
					// generate again a new position
					currentObj--;
					previousObj=0;
				}
			}
		}
	}

	object[robotID].moveSpeed = (float)1.75;
	object[personID].moveSpeed = (float)1;

}
//==================================================================================================================//
//==================================================================================================================//
void init_variables(int currentObj){
	object[currentObj].collide=(int)0;
	object[currentObj].moveSpeed=(int)0;
	object[currentObj].move_directionX=(int)0;
	object[currentObj].move_directionY=(int)0;
	object[currentObj].moveSpeed=(int)0;
	object[currentObj].radius=(float)0.3f;
	object[currentObj].available =(int)1;
	object[currentObj].person_collide=(int)0;
}
//==================================================================================================================//
//==================================================================================================================//
void generate_starting_position(int currentObj){
	object[currentObj].x = (float)uniform_distribution_ranges(zero,workshop_sizeX);
	object[currentObj].y = (float)uniform_distribution_ranges(zero,workshop_sizeY);
	object[currentObj].z = zero;
}
//=================================================================================================================//
//==================================================================================================================//
// Generates uniform distribution between rangeLow and rangeHigh
int uniform_distribution_ranges(int rangeLow, int rangeHigh) {
    double myRand = rand()/(1.0 + RAND_MAX);
    int range = rangeHigh - rangeLow + 1;
    int myRand_scaled = (myRand * range) + rangeLow;
    return myRand_scaled;
}
//==================================================================================================================//
//==================================================================================================================//
int objectsToCollect(void){
	int objectID,stillMissing=0;

	// sum all available objects, exempt the person and the robot
	// if the sum is zero, then stop... all objects were collected
	for(objectID=0;objectID<totalObjects;objectID++){
		stillMissing+=object[objectID].available;
	}
	return(stillMissing);
}
//==================================================================================================================//
//==================================================================================================================//
int main(void) {

	workshop_API(); // API : Application Programming Interface

	return 0;
}
//==================================================================================================================//
//==================================================================================================================//
