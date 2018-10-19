format_string 
= t:text_wrap tt:( maybe_format text_wrap )* {
	let res = [t];
    [...tt.map(e=>[...e])].forEach(e=>res.push(...e))
    return res;
}
text_wrap
= text:text {
	return {type:'plain',text}
}
maybe_format 
= '{' '{' {
	return {type:'plain',text:'\u007b'};
}
/ '}' '}' {return {type:'plain',text:'\u007d'};}
/ f:format {
	return f
}
format 
= '{' arg:( argument )? spec:( ':' format_spec )* '}' {
	return {
    	type:'format',
        arg,
        spec:spec&&spec.map(e=>e[1])
    }
}
argument 
= integer 
/ identifier

format_spec 
= align:(fill:(fill)?align)?sign:(sign)?sharp:('#')?zero:('0')?width:(width)?precision:('.' precision)?type:(type)? {
	return {
    	align:align&&{
        	fill:align[0],
            align:align[1]
        },
        sign,
        sharp: !!sharp,
        zero: !!zero,
        width,
        precision:precision&&precision[1],
        type
    }
}
fill
= character
align
= '<' / '^' / '>'
sign
= '+' / '-'
width
= count
precision
= count / '*'
type
= name:identifier typeArgs: typeArgs? {
	return {
    	typeKind:'normal',
       	name,
       	typeArgs
    }
}
/ '?' {
	return {typeKind:'debug'}
} 
/ '' {
	return {typeKind:'any'}
}
typeArgs 
= '(' t:arg tt:( ',' arg )* ')' {
	return [t,...tt.map(e=>e[1])]
}
arg 
= text
count 
= parameter / integer
parameter 
= argument '$'

text 
= t:[a-zA-Z ]* {return t.join('')}
integer 
= t:[0-9]+ {return parseInt(t.join(''),10)}
identifier 
= t:[a-zA-Z]+ {return t.join('')}
character 
= t:[a-zA-Z0-9] {return t}
