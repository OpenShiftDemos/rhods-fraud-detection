# Fraud Detection with Red Hat OpenShift Data Science
Red Hat OpenShift Data Science is a managed cloud service for data scientists
and developers of intelligent applications. It provides a fully supported
sandbox in which to rapidly develop, train, and test machine learning (ML)
models in the public cloud before deploying in production.

The content in this repository describes how to use OpenShift Data Science to
train and test a relatively simplistic fraud detection model. In exploring this
content, you will become familiar with the OpenShift Data Science offering and
common workflows to use with it.

## Access OpenShift Data Science
In order to use the content in this repository, you need to already have access
to an OpenShift Data Science environment. Using the access credentials provided
to you, log into the OpenShift Data Science portal.

## Launch Jupyter Hub
OpenShift Data Science makes extensive use of Jupter Hub, a project that enables
users to quickly and easily launch Jupyter Notebooks to conduct data and feature
engineering, experimentation, model training, and testing.

**NEED IMAGE**

From the OpenShift Data Science portal page, click the Jupyter Hub link. Use the
same credentials that you used to access the OpenShift Data Science portal.

## Launch a Notebook
When you first access Jupyter Hub, you will see a configuration screen that asks you which notebook image to use as the base for your project, as well as for some other details. Ensure that _Standard Data Science_ is selected for the notebook image. Then click _Start Server_.

**NEED IMAGE**

## Clone Git Repository
Once your notebook image is launched, at the left-hand side of the notebook console is a Git icon. Click the Git icon and then click _Clone a Repository_. 

In the window that pops up, copy the Git URL for this repository and paste it into the box:

```
https://github.com/OpenShiftDemos/rhods-fraud-detection.git
```

Then, click _CLONE_.

In the file browser, you will now see a folder for the repository that was cloned.

**NEED IMAGE**