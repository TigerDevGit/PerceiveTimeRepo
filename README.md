# Toggl public web

## Source of awesomeness

1. Tasks
2. Releasing

## Tasks

> all tasks named here are grunt tasks. 

#### Serve

Builds the application and serves it. By default will use port 9000 for the website.  
If there is a need to change the port then use the env variable `PORT=xxx`

Will initiate the `build:serve` step

#### Build:serve

Builds the bundle for serving.

Steps:

1. Copy all files under `./dist`
2. Browserify bundles
3. Autoprefix css
4. Download and bundle modernizr 
5. Copy folders and files under `./app/static-pages` to `./dist`. Will expand the folder.  

#### Build

Builds the bundle for production release

Steps (include all the steps from build:serve):

1. Goes through index.html and uses grunt usemin to figure out concat, uglify and rev steps
2. Concatenates found targets
3. Uglifies found target  
4. Cssmins all css files under `./dist`
5. Revisions files (there are a few exceptions)
6. Replace references of minimized/revved resources wherever possible
7. Minimize all html files
8. Create .gz of all files. We need this because its much more efficient then letting nginx do it on the fly.
9. Creates HTML snapshots from all the backbone application pages. HtmlSnapshot task.

**Before releasing MAKE SURE that the htmlSnapshot taks is passing! If its not then you should not release!**

#### htmlSnapshot

Oh fun. This thing needs the app to be running. So before running it make sure you have a running `grunt serve` task.  
How it works? It pretty much just navigates to given pages, on each page it waits a bit and creates a save of that page.  
No images, no styles, just a html spaghetti. 

Those files are saved to `./dist/static` folder and are served by nginx if the requester is a crawler. 
 
## Releasing

#### Shipit

We use [shipit](https://github.com/shipitjs/shipit) to deploy our website.  
Shipit tasks lie in [shipitfile.js](https://github.com/toggl/website/blob/master/shipitfile.js). Check it out how it works.

#### How to release?

1. Make sure you have shipit installed
`npm install -g shipit`

tasks:  

* shipit |environment| deploy 
* shipit |environment| deploy bump
* shipit |environment| deploy bump:minor
* shipit |environment| deploy bump:major

Shipit runs `grunt build internally`
