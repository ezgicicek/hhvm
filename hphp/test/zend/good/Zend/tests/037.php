<?hh

namespace Closure;

class Closure { static $x = 1;}
<<__EntryPoint>> function main(): void {
$x = __NAMESPACE__;
\var_dump(Closure::$x);

\var_dump($x::$x);
}
