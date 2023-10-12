(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class StackCommand {
    getChar(): String {
        "Called from base class"
    };

    evaluate(node: StackNode): StackNode {
        let ret: StackNode in {
            (new IO).out_string("Undefined execution!\n");
            ret;
        }
    };

    getNumber(): Int {
        0
    };
};

class Integer inherits StackCommand {
    number: Int;

    init(num: Int): SELF_TYPE {
        {
            number <- num;
            self;
        }
    };

    evaluate(node: StackNode): StackNode {
        node
    };

    getNumber(): Int {
        number
    };

    getChar(): String {
        (new A2I).i2a(number)
    };
};

class Plus inherits StackCommand {
    init() : SELF_TYPE {
        self
    };

    evaluate(node: StackNode): StackNode {
        let n1: StackNode <- node.getNextNode(),
            n2: StackNode <- n1.getNextNode(),
            sum: Int,
            ret: StackNode in {
                if (not (isvoid n1)) then
                    if (not (isvoid n2)) then {
                        sum <- n1.getCommand().getNumber() + n2.getCommand().getNumber();
                        ret <- (new StackNode).init((new Integer).init(sum), n2.getNextNode());
                    }
                    else
                        0
                    fi
                else
                    0
                fi;
                ret;
            }
    };

    getChar(): String {
        "+"
    };
};

class Swap inherits StackCommand {
    init() : SELF_TYPE {
        self
    };

    evaluate(node: StackNode): StackNode {
        let nextNextNode: StackNode <- node.getNextNode().getNextNode() in {
            node.getNextNode().setNextNode(nextNextNode.getNextNode());
            nextNextNode.setNextNode(node.getNextNode());
            nextNextNode;
        }
    };

    getChar(): String {
        "s"
    };
};

class StackNode {
    command : StackCommand;
    next : StackNode;

    init(c: StackCommand, n: StackNode): StackNode {
        {
            command <- c;
            next <- n;
            self;
        }
    };

    push(command: StackCommand): StackNode {
        let node: StackNode in {
            node <- (new StackNode).init(command, self);
            node;
        }
    };

    getCommand(): StackCommand {
        {
            command;
        }
    };

    getNextNode(): StackNode {
        {
            next;
        }
    };

    setNextNode(node: StackNode): StackNode {
        next <- node
    };
};

class Main inherits IO {
    stackTop: StackNode;

    display(): Object {
        let node: StackNode <- stackTop in {
            while (not (isvoid node)) loop
            {
                out_string(node.getCommand().getChar());
                out_string("\n");
                node <- node.getNextNode();
            }
            pool;
        }
    };

    pushCommand(command: StackCommand): StackCommand {
        {
            if (isvoid stackTop) then {
                let nil: StackNode in {
                    stackTop <- (new StackNode).init(command, nil);
                };
            } else {
                stackTop <- stackTop.push(command);
            } fi;
            command;
        }
    };

    execute(inputString: String): Object {
        {
            if (inputString = "+") then {
                pushCommand((new Plus).init());
            }
            else
                if (inputString = "d") then
                    display()
                else 
                    if (inputString = "e") then
                        let node: StackNode <- stackTop in {
                            if (not (isvoid node)) then
                                stackTop <- node.getCommand().evaluate(node)
                            else
                                0
                            fi;
                        }
                    else
                        if (inputString = "s") then
                            pushCommand((new Swap).init())
                        else
                            pushCommand((new Integer).init((new A2I).a2i(inputString)))
                        fi
                    fi
                fi
            fi;
        }
    };

    main() : Object {
        let inputString: String in {
            while (not (inputString <- in_string()) = "x") loop
            {
                out_string(">");
                out_string(inputString);
                out_string("\n");
                execute(inputString);
            }
            pool;
        }
    };
};