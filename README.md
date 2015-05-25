# Aspect For Delphi #
The Aspect4Delphi consists of an API that enables the use of the concept of [aspect-oriented programming (AOP)](http://en.wikipedia.org/wiki/Aspect-oriented_programming) in Delphi. 

Consisting primarily of removing the crosscutting concerns ("crosscutting" or "separation of concerns") of a program in Delphi.

Some examples of [OOP](http://en.wikipedia.org/wiki/Object-oriented_programming) issues are the "logs" of applications and the security part. In such cases, by working with objects, overdependence on objects that are the logs and the security part is inevitable, which is known as transverse interest, logs and security, not part of the core business ("core- business") of the application, but are sorely needed. To solve these problems was created the Aspect4Delphi.

The Aspect4Delphi requires Delphi XE or greater.

# Using Aspects #

First you must add the Aspect4Delphi in your IDE or project. Simply add the Search Path of your IDE or your project the following directories:

- Aspect4Delphi\src

Now you must implement and register your aspect. I will show an example for use of a logging mechanism. Create a new Unit and set its aspect. For this to Uses of Aspect4D.pas and implement the IAspect interface. It is important to use the heritage of TAspect base class. The IAspect interface defines what will be intercepted before, after and in the event of an exception in implementing the method defined in the context of aspects.

You can create specific exceptions of its aspect as in this example. Also, you must define a custom attribute (inheritance AspectAttribute) to annotate the methods you want to enter in the context of aspects.

    uses
      Aspect4D,
      System.Rtti,
      System.SysUtils,
      System.Classes;

    Type

    ELoggingException = class(Exception);

    LoggingAttribute = class(AspectAttribute);
    
    TLoggingAspect = class(TAspect, IAspect)
    public
      procedure DoBefore(pInstance: TObject;
        pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pDoInvoke: Boolean;
        out pResult: TValue);
    
      procedure DoAfter(pInstance: TObject;
        pMethod: TRttiMethod; const pArgs: TArray<TValue>; var pResult: TValue);
    
      procedure DoException(pInstance: TObject;
        pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pRaiseException: Boolean;
        pTheException: Exception; out pResult: TValue);
    end;

    procedure TLoggingAspect.DoAfter(pInstance: TObject; pMethod: TRttiMethod;
      const pArgs: TArray<TValue>; var pResult: TValue);
    var
      vAtt: TCustomAttribute;
    begin
      for vAtt in pMethod.GetAttributes do
    	if vAtt is LoggingAttribute then
      		GlobalLoggingList.Add('After ' + 
				pInstance.QualifiedClassName + ' - ' + pMethod.Name);
    end;
    
    procedure TLoggingAspect.DoBefore(pInstance: TObject; pMethod: TRttiMethod;
      const pArgs: TArray<TValue>; out pDoInvoke: Boolean; out pResult: TValue);
    var
      vAtt: TCustomAttribute;
    begin
      for vAtt in pMethod.GetAttributes do
    	if vAtt is LoggingAttribute then
      		GlobalLoggingList.Add('Before ' + 
				pInstance.QualifiedClassName + ' - ' + pMethod.Name);
    end;
    
    procedure TLoggingAspect.DoException(pInstance: TObject; pMethod: TRttiMethod;
      const pArgs: TArray<TValue>; out pRaiseException: Boolean; 
	  pTheException: Exception; out pResult: TValue);
    var
      vAtt: TCustomAttribute;
    begin
      for vAtt in pMethod.GetAttributes do
    	if vAtt is LoggingAttribute then
     		 GlobalLoggingList.Add('Exception ' + 
				pInstance.QualifiedClassName + ' - ' 
				+ pMethod.Name + ' - ' + pTheException.Message);
    end;

You must register the aspect created in the context of AOP. You can do this in the **initialization** section of the own Unit.

    initialization
    Aspect.Register(TLoggingAspect);

Now to use their appearance, you simply add the custom attribute in their methods and remember to leave them as **virtual** (this is necessary because Delphi can only intercept the virtual methods).

    
     TCar = class
     public
    	constructor Create;
    	destructor Destroy; override;
    
    	[Logging]
    	procedure Insert(); virtual;
    
    	[Logging]
    	procedure Update(); virtual;
    
    	[Logging]
    	procedure Delete(); virtual;
     end;

To create the instance you must add the same in Weaver, to automate you can do this in constructors and destructors methods of each class.

    constructor TCar.Create;
    begin
      Aspect.Weaver.Proxify(Self);
    end;
    
    destructor TCar.Destroy;
    begin
      Aspect.Weaver.Unproxify(Self);
      inherited;
    end;

Basically what it takes to use the Aspect4Delphi:

- Create your aspect implementing IAspect interface.
- Register your aspect using the Aspect.Register().
- Add the instance to the context using the Aspect.Weaver.Proxify().
- Remove the instance of using the context Aspect.Weaver.Unproxify();