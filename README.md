# IGNW GCP Provisioner

Creates a privileged GCP provisioner project and service account for purpose of project and folder management.

On a top level project, or within an individual project, It is strongly recommended to isolate project and folder management. This is because these resource types will require heightened service account privileges. In some cases even organization-level control. It is desired that very few administrators have access to such service accounts.

When dealing with multi-tenancy, a “project of projects” pattern can really help organizations manage potential sprawl. In this model, we use a master project to drive the creation of all other projects within the account. A superuser service account is created here, with abilities to control organization-wide objects such as folders and projects and objects that need organizational approval, such as certain network changes. Users should not be using this project for any development or production purposes, and this service account should be interacted with only through a CI/CD process. This is your GCP/Terraform management plane, and should be secured as such.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [tools](http://www.tools-path.com) - Tools used
* [more tools](https://www.tools-path.com) - More tools used

## Contributing

Please read [CONTRIBUTING.md](https://ignw-contributing) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Author Name** - *Initial work*

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the <license> License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
