#include <ruby.h>
#include "ast.h"

VALUE rb_cVar;
VALUE rb_cAnd;
VALUE rb_cOr;
VALUE rb_cNot;
VALUE rb_eParseError;

/**
 * Transforms the C AST to a Ruby AST.
 */
static VALUE transform(Node *node) {
    switch (node->type) {
    case eVAR:
        return rb_funcall(rb_cVar, rb_intern("new"), 1, rb_str_new2(((Var*)node)->value));
    case eAND:
        return rb_funcall(rb_cAnd, rb_intern("new"), 2, transform(((Binary*)node)->left), transform(((Binary*)node)->right));
    case eOR:
        return rb_funcall(rb_cOr,  rb_intern("new"), 2, transform(((Binary*)node)->left), transform(((Binary*)node)->right));
    case eNOT:
        return rb_funcall(rb_cNot, rb_intern("new"), 1, transform(((Unary*)node)->refnode));
    default:
        rb_raise(rb_eArgError, "Should never happen");
        return 0;
    }
}

static VALUE Bool_parse(VALUE klass, VALUE r_expr) {
    Node* ast;
    char* expr;

    if(NIL_P(klass)) {
        rb_raise(rb_eRuntimeError, "Bool klass was nil");
    }

    // TODO: Verify that r_expr is a String
    expr = RSTRING_PTR(r_expr);
    ast = parse_ast(expr);
    if(ast != NULL) {
        VALUE result = transform(ast);
        free_ast(ast);
        return result;
    } else {
        rb_raise(rb_eParseError, "%s", last_error_msg);
    }
}

void Init_bool_ext() {
    VALUE rb_mBool; 
    VALUE rb_eStandardError;
    VALUE rb_cBinary;
    VALUE rb_cUnary;

    rb_eStandardError = rb_const_get(rb_cObject, rb_intern("StandardError"));
    rb_mBool = rb_define_module("Bool");
    rb_eParseError = rb_define_class_under(rb_mBool, "ParseError", rb_eStandardError);

    rb_cBinary = rb_define_class_under(rb_mBool, "Binary", rb_cObject);
    rb_cUnary = rb_define_class_under(rb_mBool, "Unary", rb_cObject);
    rb_cVar = rb_define_class_under(rb_mBool, "Var", rb_cObject);
    rb_cAnd = rb_define_class_under(rb_mBool, "And", rb_cBinary);
    rb_cOr  = rb_define_class_under(rb_mBool, "Or", rb_cBinary);
    rb_cNot = rb_define_class_under(rb_mBool, "Not", rb_cUnary);

    rb_define_singleton_method(rb_mBool, "parse", Bool_parse, 1);
}
