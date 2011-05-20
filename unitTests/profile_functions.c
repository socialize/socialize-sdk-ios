#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>


// Add flag -finstrument-functions to "Other C Flags" under <compiler> - Language

void __cyg_profile_func_enter (void *, void *) __attribute__((no_instrument_function));
void __cyg_profile_func_exit (void *, void *) __attribute__((no_instrument_function)); 

void __cyg_profile_func_enter(void *func, void *caller) {
	
	char* atosCommand = (char*)malloc(128);
	sprintf(atosCommand, "/Developer/usr/bin/atos -p %d %p\n", getpid(), func);
	
	FILE *stream = popen(atosCommand, "r");
	char buff[256];
	while(fgets(buff, sizeof(buff), stream) != '\0') {
		printf("%s", buff);
	}
	pclose(stream);
	
	free(atosCommand);
}

void __cyg_profile_func_exit (void *func, void *caller) {
	// do nothing	
}
