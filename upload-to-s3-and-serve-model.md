### Prerequisite

- S3 bucket
- RHODS cluster/sandbox

### Step 1: Download the openvino IR files
Download the files from your Notebook's file explorer to your local.

![download](gif/download-ir-files.gif)

Organise the downloaded files as shown below which is in accordance with guidelines of [openvino model repository](https://github.com/openvinotoolkit/model_server/blob/main/docs/models_repository.md#preparing-a-model-repository-ovms_docs_models_repository)

![structure](images/directory-structure.png)

### Step 2: Upload the files to your S3 bucket
Use your amazon console to upload files to your bucket.

![upload-to-s3](gif/upload-to-s3.gif)

### Step 3: Create Data connections, configure server and deploy the model
<ol type="a">
<li>Head over to your RHODS ODS dashboard to your Datascience project.</li>

click _Add data connection_</br>
![add-data-connection](images/add-data-connection.png)

Configure the data connection with respective values and click _Add data connection_</br>
![data-conn-config](images/data-conn-config.png)

<li>Next configure the server and **make sure** to make the route accessible externally.</li>

Click _Configure_</br>
![configure-server](gif/configure-server.gif)

<li>Deploy the model to be served</li>

Click _Deploy_</br>
![deploy-model](gif/deploy-model.gif)


Copy the inference link and head back to the [Notebook.ipynb](Notebook.ipynb)
</ol>