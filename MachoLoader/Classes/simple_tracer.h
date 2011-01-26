/* Code sample: using ptrace for simple tracing of a child process.
**
** Eli Bendersky (http://eli.thegreenplace.net)
** This code is in the public domain.
*/
//#include <stdio.h>
//#include <stdarg.h>
//#include <stdlib.h>
//#include <signal.h>
////#include <syscall.h>
//#include <sys/types.h>
//#include <sys/ptrace.h>
//#include <sys/wait.h>
////#include <sys/reg.h>
//#include <sys/user.h>
//#include <unistd.h>
//#include <errno.h>
//

void run_target( const char *programname );

void run_debugger( pid_t child_pid );

int simple_tracer( const char *programname );
