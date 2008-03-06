<#assign reserved = ["isnull", "isnotnull", "toString", "hashCode", "getClass", "notify", "notifyAll", "wait"]>
package ${package};

<#if (dtoTypes?size > 0)>
import static com.mysema.query.grammar.HqlGrammar.*;
</#if>
import static com.mysema.query.grammar.Types.*;

/**
 * ${classSimpleName} provides types for use in Query DSL constructs
 *
 */
public class ${classSimpleName} {

${include}

<#list dtoTypes as decl>
    public static final class ${pre}${decl.simpleName} extends Constructor<${decl.name}>{
    <#list decl.constructors as co>    
        public ${pre}${decl.simpleName}(<#list co.parameters as pa>Expr<${pa.typeName}> ${pa.name}<#if pa_has_next>,</#if></#list>){
            super(${decl.name}.class<#list co.parameters as pa>,${pa.name}</#list>);
        }
    </#list>            
    }
    
</#list>               
<#list domainTypes as decl>               
    public static final class ${pre}${decl.simpleName} extends PathEntity<${decl.name}>{
	<#list decl.stringFields as field>
    	public final PathString ${field.name} = _string("${field.name}");
    </#list>    
    <#list decl.booleanFields as field>
    	public final PathBoolean ${field.name} = _boolean("${field.name}");
    </#list>
    <#list decl.simpleFields as field>
		public final PathComparable<${field.typeName}> ${field.name} = _comparable("${field.name}",${field.typeName}.class);
    </#list>
    <#list decl.collectionFields as field>
    	public final PathEntityCollection<${field.typeName}> ${field.name} = _collection("${field.name}",${field.typeName}.class);
    	public ${pre}${field.simpleTypeName} ${field.name}(int index) {
    		return new ${pre}${field.simpleTypeName}(this+".${field.name}["+index+"]");
    	}
    </#list>
  	<#list decl.entityFields as field>
        public final PathEntityRenamable<${field.typeName}> ${field.name} = _entity("${field.name}",${field.typeName}.class);
	</#list>     
        ${pre}${decl.simpleName}(String path) {super(${decl.name}.class,path);}
  	<#list decl.entityFields as field>
  	<#if !reserved?seq_contains(field.name)>
  	    private ${pre}${field.simpleTypeName} _${field.name};
        public ${pre}${field.simpleTypeName} ${field.name}() {
            if (_${field.name} == null) _${field.name} = new ${pre}${field.simpleTypeName}(this+".${field.name}");
            return _${field.name};
        }
    </#if>
	</#list>  
    }
        
</#list>
    
}
