# About functions

- Notes from: [Linux Command Line and Shell Scripting Bible](https://a.co/d/5wkMxVg)


## Return value

:one: The default exit status:

- By default, the exit status of a function is the exit status returned by **the last command in the function**.
- After the function executes, you use the standard `$?` variable to determine the exit status of the function
- Using the default exit status of a function can be a dangerous practice - as it's the last executed, and you have no way of knowing whether or not any of the other commands in the function completed successfully

:two: Using the `return` command

- Remember to retrieve the return value as soon as the function completes.
  - If you execute any other commands before retrieving the value of the function using the $? variable, the return value from the function is lost.
- Remember that an exit status must be in the range of 0 to 255.
  -  Any value over that returns an error value. Try input 200 for below
  -  You cannot use this return value technique if you need to return either larger integer values or a string value.

```bash
function dbl {
    read -p "Enter a value: " value
    echo "doubling the value"
    return $[ $value * 2 ]
}

dbl
echo "$?"
```

:three: Using function output

- You can use this technique to retrieve any type of output from a function to assign to a variable
- If you had used an `echo` statement to produce this query message to the user, it would have been captured by the shell variable as well as the output value. (On the other hand, using `read -p` will make sure it's not in STDOUT)
- Using this technique, you can also return floating-point and string value

```bash
function dbl {
    read -p "Enter a value: " value
    echo "doubling the value"
    echo $[ $value * 2 ] # not return as above
}

result=$(dbl) # capture the output of a function to a shell variable
echo "$result"
```

## Passing parameters to a function

- the name of the function is defined in the `$0` variable, and
- any parameters on the function command line are defined using the variables `$1`, `$2`, and so on.
- You can also use the special variable `$#` to determine the number of parameters passed to the function.

## Scope of a variable

- The scope is where the variable is visible. Variables defined in
functions can have a different scope than regular variables—that is, they
can be hidden from the rest of the script

:one: Global variables

- Global variables are variables that are **valid anywhere within the shell script.**
- If you define a global variable in the main section of a script, you can retrieve its value inside a function. 
- Likewise, **if you define a global variable inside a function, you can retrieve its value in the main section of the script.**
- :rotating_light: **By default, any variables you define in the script are global variables.**
- Variables defined outside a function can be accessed within the function just fine. This practice can be dangerous:
  - Because the `$temp` variable was used in the function, its value is compromised in the script
  - Global variable requires that you know exactly what variables are used in the function, including any variables used to calculate values not returned to the script.

```bash
#!/bin/bash
function func1 {
    temp=$[ $value + 5 ]
}
temp=4
value=6
func1
echo "The result is $temp $value" # shows 11, 6 ... temp got modified
```

:two: Local variables

- Any variables that the **function uses internally** can be declared as local variables.
- The local keyword ensures that the variable is limited to within the function.

```bash
#!/bin/bash
function func1 {
    local temp=$[ $value + 5 ] # declare local this time
}
temp=4
value=6
func1
echo "The result is $temp $value" # shows 4, 6 ... much better
```

## Passing arrays to functions

- If you try to pass the array variable as a single parameter, it doesn't work. The function only picks up the first value of the array variable.

```bash
#!/bin/bash
function testit {
    echo "The parameters are: $@"
    thisarray=$1
    echo "The received array is ${thisarray[*]}"
}

myarray=(1 2 3 4 5)
echo "The original array is: ${myarray[*]}"
testit $myarray
```

- To solve this problem, you must disassemble the array variable into its individual values and use the values as function parameters. Inside the function, you can reassemble all the parameters into a new array variable

```bash
function testit {
    local newarray
    newarray=(`echo "$@"`)
    echo "The new array value is: ${newarray[*]}"
}
```

## Returning arrays from functions

- Similar technique: The function uses an `echo` statement to output the individual array values in the proper order, and the script must reassemble them into a new array variable:

```bash
function arraydblr {
    local origarray
    local newarray
    local elements
    local i
    origarray=($(echo "$@"))
    newarray=($(echo "$@"))
    elements=$[ $# - 1 ]
    for (( i = 0; i <= $elements; i++ ))
    {
        newarray[$i]=$[ ${origarray[$i]} * 2 ]
    }
    echo ${newarray[*]}
}

myarray=(1 2 3 4 5)
echo "The original array is: ${myarray[*]}"
arg1=$(echo ${myarray[*]})
result=($(arraydblr $arg1))
echo "The new array is: ${result[*]}"
```

## Considering Function Recursion (tmp @ 663/1113 of  [Linux Command Line and Shell Scripting Bible](https://a.co/d/5wkMxVg)