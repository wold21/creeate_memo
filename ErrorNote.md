# Flutter ErrorNote 📝

## RenderFlex Overflow Error

`"The overflowing RenderFlex has an orientation of Axis.vertical."`
Column 위젯 또는 수직 방향의 Flex위젯에 자식 요소가 너무 많거나 크기가 커서 화면을 넘어간다는 뜻이다. 여기서 Flex위젯은 Row, Column이 있다. 나의 경우엔 최상단에 위치한 Column을 기준으로 스크롤이 포함된 자식 요소가 있었다. 이럴때 플러터는 넘치는 부분을 노란색과 검은색으로 부각시켜 오버되는 영역을 가시적으로 보여준다.

### Flex의 특성

-   자식의 natural size를 사용하여 배치한다.
-   자식의 크기가 고정되어있는 경우에는 자식들이 차지하는 공간이 너무 클 수 있다.

> Natural size란?  
> 플러터에서 위젯이 스스로 결정하는 크기를 의미한다. 즉, 위젯의 콘텐츠나 속성에 따라 자동으로 설정되는 크기를 말함.  
> 예를 들면 텍스트 위젯에서 글자의 길이나 폰트 사이즈에 따라 위젯의 크기가 달라지는 것이 있다.

### 해결 방법

1. Expended 위젯이나 Flexible 위젯을 사용하여 자식 위젯 즉, Flex 위젯이 남은 공간을 차지하도록 만들어 주면 된다.
2. Flexible 위젯을 `SingleChildScrollView`로 감싸 내용이 화면을 넘어갈 경우 스크롤이 생기게함.
3. ListView에서 shrinkWrap의 옵션을 true로 설정하여 ListView를 자식 요소의 크기에 맞춰서 축소되도록 할 수 있다.
