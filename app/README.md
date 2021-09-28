odh-s2i-project-simple
==============================

Simple, unstructured, and unopinionated project for data science that is deployable as an OpenShift s2i Application.

The purpose is to allow data science exploration to easily transition into deployed services and applications on the OpenShift platform.

## Project Organization
```
├── README.md
├── LICENSE
├── requirements.txt        <- Used to install packages for s2i application
├── 0_start_here.ipynb      <- Instructional notebook
├── 1_run_flask.ipynb       <- Notebook for running flask locally to test
├── 2_test_flask.ipynb      <- Notebook for testing flask requests
├── .gitignore              <- standard python gitignore
├── .s2i                    <- hidden folder for advanced s2i configuration
│   └── environment         <- s2i environment settings
├── gunicorn_config.py      <- configuration for gunicorn when run in OpenShift
├── prediction.py           <- the predict function called from Flask
└── wsgi.py                 <- basic Flask application
```
--------

## Using this template

After creating a new repository using this template (clicking Use this template) up above, you will have a very simple s2i python project with notebooks included.

## One Time Project Set Up

This follows the normal developer workflow for OpenShift s2i projects from git.  You can do so from the OpenShift console or the command line using the `oc` CLI.

#### Log in to OpenShift
Full documentation [here](https://docs.okd.io/latest/cli_reference/openshift_cli/getting-started-cli.html#cli-logging-in_cli-developer-commands) 
```shell
oc login --token=sha256~XYZ --server=https://api.my-cluster:6443
```
#### Create a new OpenShift Project
Create a new project namespace.
Full documentation [here](https://docs.okd.io/latest/cli_reference/openshift_cli/developer-cli-commands.html#new-project).
```shell
oc new-project {project name}
```

#### Create the OpenShift Application
Create the application using the [web console](https://docs.okd.io/latest/applications/application_life_cycle_management/odc-creating-applications-using-developer-perspective.html#odc-importing-codebase-from-git-to-create-application_odc-creating-applications-using-developer-perspective) or the [CLI](https://docs.okd.io/latest/cli_reference/openshift_cli/developer-cli-commands.html#new-app)
```shell
oc new-app https://github.com/{my-org}/{my-rhods-project}
```
Observe the new application workload as it is deployed.  This should included a Deployment, BuildConfig, and Service.  You can navigate to your newly created project and view the topology.

#### Create a Route (Optional)
To use the service endpoint externally, expose a route to the new endpoint.  This is included in the web console creation of applications but can be done using the [CLI](https://docs.okd.io/latest/cli_reference/openshift_cli/developer-cli-commands.html#expose)
```shell
oc expose svc/{project service name}
```

#### Add Webhook to GitHub (Optional)
If you want to update the served model when application code is pushed to GitHub, they can set up a webhook.  This webhook will trigger a new build of the container and deploy it as an updated deployment.  This is not necessary if you prefer to manually update the served model by triggering a build. GitHub [documentation](https://docs.github.com/en/developers/webhooks-and-events/creating-webhooks)

1. Get the webhook from the newly created application’s Build Config from the UI.
   1. Navigate to your application’s new Build Config
   1. Under Details -> Webhooks -> GitHub click “Copy URL with Secret”
1. Create the webhook in GitHub
   1. In the project repo click Settings -> Webhooks
   1. Click Add webhook
   1. Paste the value from BuildConfig
   1. Change Content type to JSON
   1. Click Add Webhook to save

#### Give Access
Give other users access to the created project. https://github.com/{my-org}/{my-rhods-project}.  Other users may want to (fork and) clone the project to work on it from inside their Jupyter environment.


## Data Science Workflow
1. Visit the RHODS dashboard
1. Launch JupyterHub
1. Spawn notebook
   1. Select notebook image
   1. Select notebook size
   1. Enter number of GPUs
   1. Enters environment variables.  (e.g. credentials, endpoint URL, etc)
   1. Click “Start”
1. Clone the created project repository using JupyterLab extension or terminal command line 
   1. Click plugin icon
   1. Click “Clone a Repository”
   1. Enter repository URL of the newly created GitHub repository (step 5 in Application Setup) and click “Clone”. Alternatively, a team could use a fork and pull request flow.
1. Experiment with the data and create a prediction algorithm.  This is probably a very familiar task for data scientists.
1. Open “Start Here” notebook (start_here.ipynb) that provides steps for experimentation with the goal of creating a prediction function.  (e.g. experiment, create function, test function)
1. Extract prediction to a function in a Python file (prediction.py)
The “Start Here” notebook includes instructions for extracting the function from the notebook into prediction.py.  Must be explanatory and easy to understand. In addition, we should offer sample prediction functions of popular libraries showing how to load serialized models from Python.
User pulls only the necessary code into a separate function in prediction.py which is called from the flask app route handler.
1. Update the `requirements.txt`
1. Test prediction function from notebook
    ```python
    from prediction import predict
    
    predict(data)
    ```
1. Test the Flask application locally using the new prediction function from a Jupyter notebook
   1. Run the Flask app (run_flask.ipynb provided - click play all cells) on your notebook server.
    ```
    !FLASK_APP=wsgi.py flask run
    ```
   1. Test the local Flask app (test_flask.ipynb provided) running on your notebook server.  Both curl commands and python code will be provided.
!curl -X POST -H "Content-Type: application/json" --data '{"data": "hello world"}' http://localhost:5000/prediction
   1. Stop the flask app  when complete. (Click the stop button in run_flask.ipynb)
1. Save code to GitHub using push.  Be sure to include all relevant models, prediction python files, and any pertinent notebooks.
   1. Click GitHub plugin
   1. Click upload icon
   1. Enter username and password/token


## Using the Served Model 

### Building the Application
To test changes, the application must be rebuilt and redeployed.If a webhook was configured, OpenShift will automatically deploy the updated service with the new model. Application deployment will show a rollout and new pods are spawned.  If no webhook was configured, the “Build” button must be pressed on the build config or triggered via command line.

#### Test deployed application endpoint
The application's service endpoint can be tested using cURL or python code from Jupyter notebooks or the terminal.
```
!curl -X POST -H "Content-Type: application/json" --data '{"data": "hello world"}' http://rhods-project.apps.cluster/prediction
```

