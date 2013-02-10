#include <ruby.h>
#include "ast.h"
#include "unused.h"

VALUE rb_cVar;
VALUE rb_cAnd;
VALUE rb_cOr;
VALUE rb_cNot;
VALUE rb_eSyntaxError;

/**
 * Transforms the C AST to a Ruby AST.
 */
static VALUE transform(Node *node) {
    switch (node->type) {
    case eVAR:
        return rb_funcall(rb_cVar, rb_intern("new"), 1, rb_str_new2(((Var*)node)->value));
    case eAND:
        return rb_funcall(rb_cAnd, rb_intern("new"), 2, transform(((And*)node)->left), transform(((And*)node)->right));
    case eOR:
        return rb_funcall(rb_cOr,  rb_intern("new"), 2, transform(((Or*)node)->left), transform(((Or*)node)->right));
    case eNOT:
        return rb_funcall(rb_cNot, rb_intern("new"), 1, transform(((Not*)node)->other));
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
        //rb_raise(rb_eSyntaxError, "%s", last_error_msg, last_error.line, last_error.column);
        //exception = rb_exc_new2(rb_eSyntaxError, "input was < 0", last_error.line, last_error.column);
        exception = rb_funcall(rb_eSyntaxError, rb_intern("new"), 3, rb_str_new(last_error.message, strlen(last_error.message)), INT2FIX(last_error.first_line), INT2FIX(last_error.last_column));
        rb_exc_raise(exception);
    }
}

void Init_bool_ext() {
    VALUE rb_mBool; 
    VALUE rb_eStandardError;

    rb_eStandardError = rb_const_get(rb_cObject, rb_intern("StandardError"));
    rb_mBool = rb_define_module("Bool");
    rb_eSyntaxError = rb_define_class_under(rb_mBool, "SyntaxError", rb_eStandardError);

    rb_cVar    = rb_define_class_under(rb_mBool, "Var", rb_cObject);
    rb_cAnd    = rb_define_class_under(rb_mBool, "And", rb_cObject);
    rb_cOr     = rb_define_class_under(rb_mBool, "Or",  rb_cObject);
    rb_cNot    = rb_define_class_under(rb_mBool, "Not", rb_cObject);

    rb_define_singleton_method(rb_mBool, "parse", Bool_parse, 1);
}
