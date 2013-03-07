#include <ruby.h>
#include "ast.h"
#include "unused.h"

VALUE cVar;
VALUE cAnd;
VALUE cOr;
VALUE cNot;
VALUE eSyntaxError;

/**
 * Transforms the C AST to a Ruby AST.
 */
static VALUE transform(Node *node) {
    switch (node->type) {
    case eVAR:
        return rb_funcall(cVar, rb_intern("new"), 1, rb_str_new2(((Var*)node)->value));
    case eAND:
        return rb_funcall(cAnd, rb_intern("new"), 3, rb_str_new2(((And*)node)->value), transform(((And*)node)->left), transform(((And*)node)->right));
    case eOR:
        return rb_funcall(cOr,  rb_intern("new"), 3, rb_str_new2(((Or*)node) ->value), transform(((Or*)node)->left), transform(((Or*)node)->right));
    case eNOT:
        return rb_funcall(cNot, rb_intern("new"), 2, rb_str_new2(((Not*)node)->value), transform(((Not*)node)->operand));
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
    VALUE rb_eStandardError;

    rb_eStandardError = rb_const_get(rb_cObject, rb_intern("StandardError"));
    mBool = rb_define_module("Bool");
    eSyntaxError = rb_define_class_under(mBool, "SyntaxError", rb_eStandardError);

    cVar    = rb_define_class_under(mBool, "Var", rb_cObject);
    cAnd    = rb_define_class_under(mBool, "And", rb_cObject);
    cOr     = rb_define_class_under(mBool, "Or",  rb_cObject);
    cNot    = rb_define_class_under(mBool, "Not", rb_cObject);

    rb_define_singleton_method(mBool, "parse", Bool_parse, 1);
}

