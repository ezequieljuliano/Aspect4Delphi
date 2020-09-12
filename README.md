# Aspect For Delphi
The Aspect4Delphi consists of an library that enables the use of the concept of [aspect-oriented programming (AOP)](http://en.wikipedia.org/wiki/Aspect-oriented_programming) in Delphi. 

## About The Project
AOP is a programming paradigm that aims to increase modularity by allowing the separation of cross-cutting concerns. It does so by adding additional behavior to existing code without modification of the code itself. Instead, we can declare this new code and these new behaviors separately.

Aspect4Delphi helps us implement these cross-cutting concerns.

### Types of Advice
* Before advice: advice that executes before a join point, but which does not have the ability to prevent execution flow proceeding to the join point (unless it throws an exception).
* After advice: advice to be executed after a join point completes normally: for example, if a method returns without throwing an exception.
* Exception advice: Advice to be executed if a method exits by throwing an exception.

### Built With
* [Delphi Community Edition](https://www.embarcadero.com/br/products/delphi/starter) - The IDE used 

## Getting Started
To get a local copy up and running follow these simple steps.

### Prerequisites
To use this library an updated version of Delphi IDE (XE or higher) is required.

### Installation
Clone the repo
```
git clone https://github.com/ezequieljuliano/Aspect4Delphi.git
```

Add the "Search Path" of your IDE or your project the following directories:
```
Aspect4Delphi\src
```

## Usage
To provide the aspect orientation paradigm in your project with Aspect4Delphi you need:

* Implement a pointcut attribute.
* Implement a class that represents your aspect.
* Register your pointcut attribute and its aspect class in context.
* Set your classes methods to virtual.
* Write down your methods with the respective aspect.

### Sample
To illustrate usage let's look at a solution for managing logs of an application.

Implement a pointcut attribute (preferably inherits from AspectAttribute):
```
interface

uses

  Aspect.Core;

type

  LoggingAttribute = class(AspectAttribute)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

implementation

end.
```

Implement the class that represents your aspect and contains the advices methods (you must implement the IAspect interface):
```
interface

uses

  System.SysUtils,
  System.Rtti,
  Aspect,
  Aspect.Core,
  Logging.Attribute,
  App.Context;

type

  ELoggingAspectException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TLoggingAspect = class(TAspectObject, IAspect)
  private
    { private declarations }
  protected
    procedure OnBefore(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out invoke: Boolean;
      out result: TValue
      ); override;

    procedure OnAfter(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      var result: TValue
      ); override;

    procedure OnException(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out raiseException: Boolean;
      theException: Exception;
      out result: TValue
      ); override;
  public
    { public declarations }
  end;

implementation

{ TLoggingAspect }

procedure TLoggingAspect.OnAfter(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; var result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is LoggingAttribute then
    begin
      LoggingFile.Add('After the execution of ' + 
		instance.QualifiedClassName + ' - ' + 
		method.Name
	  );
      Break;
    end;
end;

procedure TLoggingAspect.OnBefore(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; out invoke: Boolean; out result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is LoggingAttribute then
    begin
      LoggingFile.Add('Before the execution of ' + 
		instance.QualifiedClassName + ' - ' + 
		method.Name
	  );
      Break;
    end;
end;

procedure TLoggingAspect.OnException(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; out raiseException: Boolean;
  theException: Exception; out result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is LoggingAttribute then
    begin
      LoggingFile.Add('Exception in executing ' + 
		instance.QualifiedClassName + ' - ' + 
		method.Name + ' - ' + 
		theException.Message
	  );
      Break;
    end;
end;

end.
```

Register your pointcut attribute and its aspect class in context (preferably keep this context in singleton instance):
```
interface

uses

  Logging.Aspect;
  Aspect.Context;  
  
function AspectContext: IAspectContext;

implementation

var

  AspectContextInstance: IAspectContext = nil;
  
function AspectContext: IAspectContext;
begin
  if (AspectContextInstance = nil) then
  begin
    AspectContextInstance := TAspectContext.Create;
    AspectContextInstance.RegisterAspect(TLoggingAspect.Create);
  end;
  Result := AspectContextInstance;
end;

end.
```

In your business rule class use the attribute to define your joins points. You can use the constructor and destructor to add your class at the Weaver.
```
interface

uses

  System.SysUtils,
  Logging.Attribute,
  App.Context;

type

  EWhatsAppMessageException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TWhatsAppMessage = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    [Logging]
    procedure Send; virtual;
  end;

implementation

{ TWhatsAppMessage }

constructor TWhatsAppMessage.Create;
begin
  inherited Create;
  AspectContext.Weaver.Proxify(Self);
end;

destructor TWhatsAppMessage.Destroy;
begin
  AspectContext.Weaver.Unproxify(Self);
  inherited Destroy;
end;

procedure TWhatsAppMessage.Send;
begin
  //Execution of send.
end;
```

## Roadmap

See the [open issues](https://github.com/ezequieljuliano/Aspect4Delphi/issues) for a list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the APACHE LICENSE. See `LICENSE` for more information.

## Contact

To contact us use the options:
* E-mail  : ezequieljuliano@gmail.com
* Twitter : [@ezequieljuliano](https://twitter.com/ezequieljuliano)
* Linkedin: [ezequiel-juliano-müller](https://www.linkedin.com/in/ezequiel-juliano-müller-43988a4a)

## Project Link
[https://github.com/ezequieljuliano/Aspect4Delphi](https://github.com/ezequieljuliano/Aspect4Delphi)