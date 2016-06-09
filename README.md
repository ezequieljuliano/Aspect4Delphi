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

    type

  	   ELoggingException = class(Exception);

  	   LoggingAttribute = class(AspectAttribute);

  	   TLoggingAspect = class(TAspect, IAspect)
  	   private
    	  { private declarations }
  	   protected
    	  function GetName: string;

    	  procedure DoBefore(instance: TObject; method: TRttiMethod;
             const args: TArray<TValue>; out invoke: Boolean; out result: TValue);

          procedure DoAfter(instance: TObject; method: TRttiMethod;
             const args: TArray<TValue>; var result: TValue);

          procedure DoException(instance: TObject; method: TRttiMethod;
             const args: TArray<TValue>; out raiseException: Boolean;
             theException: Exception; out result: TValue);
       public
          { public declarations }
  	   end;

   	{ TLoggingAspect }

	procedure TLoggingAspect.DoAfter(instance: TObject; method: TRttiMethod; 
	   const args: TArray<TValue>; var result: TValue);
	var
  	   att: TCustomAttribute;
	begin
  	   for att in method.GetAttributes do
    	 if att is LoggingAttribute then
      		GlobalLoggingList.Add('After ' + instance.QualifiedClassName + ' - ' + method.Name);
	end;

	procedure TLoggingAspect.DoBefore(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; 
	   out invoke: Boolean; out result: TValue);
	var
  	   att: TCustomAttribute;
	begin
  	   for att in method.GetAttributes do
    	 if att is LoggingAttribute then
      		GlobalLoggingList.Add('Before ' + instance.QualifiedClassName + ' - ' + method.Name);
	end;

	procedure TLoggingAspect.DoException(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; 
		out raiseException: Boolean; theException: Exception; out result: TValue);
	var
  	   att: TCustomAttribute;
	begin
  	   for att in method.GetAttributes do
    	  if att is LoggingAttribute then
      		GlobalLoggingList.Add('Exception ' + instance.QualifiedClassName + ' - ' 
					+ method.Name + ' - ' + theException.Message);
	end;

	function TLoggingAspect.GetName: string;
	begin
	   Result := Self.QualifiedClassName;
	end;

Now to use their aspect, you simply add the custom attribute in their methods and remember to leave them as **virtual** (this is necessary because Delphi can only intercept the virtual methods).

    
    TEntity = class
    public    
       [Logging]
       procedure Insert; virtual;
    
       [Logging]
       procedure Update; virtual;
    
       [Logging]
       procedure Delete; virtual;
    end;


Now create AOP context, register your aspect (for example TLoggingAspect) and use your entity to the context. 

*Note: You can set AOP context as a singleton and create a base class to the Proxify and Unproxify*. 

	uses
	   Aspect4D,
  	   Aspect4D.Impl;

	procedure CreateAndUseAspect;
	var
	   aspectContext: IAspectContext;
       entity: TEntity;
	begin
	   aspectContext := TAspectContext.Create;
  	   aspectContext.Register(TLoggingAspect.Create);

	   entity := TCarEntity.Create;
       try		
		  aspectContext.Weaver.Proxify(entity);
          entity.Insert;
          entity.Update;
          entity.Delete;
          aspectContext.Weaver.Unproxify(entity);
	   finally          
		  entity.Free;
       end;
	end;

Basically what it takes to use the Aspect4Delphi:

- Create your aspect implementing IAspect interface.
- Create AOP context and register your aspect.
- Add the instance to the context using the Proxify.
- Remove the instance of using the context Unproxify;