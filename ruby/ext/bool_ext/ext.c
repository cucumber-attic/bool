#include <ruby.h>
#include "ast.h"
#include "unused.h"

VALUE eSyntaxError;
VALUE cToken;
VALUE cVar;
VALUE cAnd;
VALUE cOr;
VALUE cNot;

/**
 * Transforms the C AST to a Ruby AST.
 */
static VALUE transform(Node *node) {
    VALUE token = rb_funcall(cToken, rb_intern("new"), 1, rb_str_new2(node->token->value));
    
    switch (node->type) {
    case eVAR:
        return rb_funcall(cVar, rb_intern("new"), 1, token);
    case eAND:
        return rb_funcall(cAnd, rb_intern("new"), 3, token, transform(((And*)node)->left), transform(((And*)node)->right));
    case eOR:
        return rb_funcall(cOr,  rb_intern("new"), 3, token, transform(((Or*)node)->left), transform(((Or*)node)->right));
    case eNOT:
        return rb_funcall(cNot, rb_intern("new"), 2, token, transform(((Not*)node)->operand));
    default:
        rb_raise(rb_eArgError, "Should never happen");
        return 0;
    }
}

static VALUE Bool_parse(VALUE klass, VALUE r_expr) {
    VALUE exception;
    Node* ast;
    char* expr;

    UNUSED(klass);

    // TODO: Verify that r_expr is a String
    expr = RSTRING_PTR(r_expr);
    ast = parse_ast(expr);
    if(ast != NULL) {
        VALUE result = transform(ast);
        free_ast(ast);
        return result;
    } else {
        exception = rb_funcall(
            eSyntaxError, rb_intern("new"), 5,
            rb_str_new(last_error.message, strlen(last_error.message)), 
            INT2FIX(last_error.first_line), 
            INT2FIX(last_error.last_line), 
            INT2FIX(last_error.first_column), 
            INT2FIX(last_error.last_column)
        );
        rb_exc_raise(exception);
    }
}

void Init_bool_ext() {
    VALUE mBool;
    VALUE cNode;
    VALUE rb_eStandardError;

    mBool = rb_define_module("Bool");
    rb_eStandardError = rb_const_get(rb_cObject, rb_intern("StandardError"));
    eSyntaxError = rb_define_class_under(mBool, "SyntaxError", rb_eStandardError);
    cNode = rb_define_class_under(mBool, "Node", rb_cObject);

    cToken  = rb_define_class_under(mBool, "Token", rb_cObject);
    cVar    = rb_define_class_under(mBool, "Var", cNode);
    cAnd    = rb_define_class_under(mBool, "And", cNode);
    cOr     = rb_define_class_under(mBool, "Or",  cNode);
    cNot    = rb_define_class_under(mBool, "Not", cNode);

    rb_define_singleton_method(mBool, "parse", Bool_parse, 1);
}

