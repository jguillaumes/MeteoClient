/*
 * ReadLight.h
 *
 *  Created on: Jan 29, 2018
 *      Author: jguillaumes
 */

#ifndef READLIGHT_H_
#define READLIGHT_H_


#define LIGHT_PIN	A6


int lightInitialize(void);
float lightRead(void);

#endif /* READLIGHT_H_ */