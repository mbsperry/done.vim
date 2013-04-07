## Done: a simple vim frontend for Google Tasks
### Version: 0.1.0

Done is vim based GUI for interacting with Google Tasks. It has some
features that I wasn't able to find in other vim google tasks plugins.
Specifically:

-  Allows for asynchronous, non-blocking communication with the Google
   Tasks server.
-  Presents the tasks in an organized fashion, and allows easy
   movement between different task lists.
-  Has a toggle function to quickly mark/unmark tasks as completed.

Missing features:

-  Does not yet support ability to add due dates, notes, etc to tasks.

Use:

-  Start Done with <leader>t
-  Quit Done with <leader>q
-  Navigation keys are in a state of flux, sorry.
-  Many normal mode keys are remapped in the buffers managed by Done.
   User beware for now until I finish the documentation.

Requirements:

-  Vim 7.3 with **Ruby** support
-  Requires my task_engine library to be installed:
   https://github.com/mbsperry/task_engine
-  Requires a Google Tasks account.

Implementation notes:

-  In order to achieve asychronous functionality, this plugin relies
   on the *task_server* daemon which is installed with the task_engine
   gem. You might see this process running in the background when
   using the plugin. It essentially handles all the communication with
   the Google Tasks server and allows for non-blocking I/O. All source
   code for task_engine and task_server is available at:
   https://github.com/mbsperry/task_engine. I am not yet distributing
   task_engine as a compiled gem, so you'll have to download it and
   install it yourself.
-  This is still very much in beta mode. Use at your own risk.

