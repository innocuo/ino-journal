import Cocoa
import Carbon

class QuietTextField: NSTextView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    
    override func keyDown(with theEvent: NSEvent) {
        Swift.print(theEvent.keyCode)
        
        let    modifiers :uint32 = GetCurrentKeyModifiers();
        Swift.print(modifiers)
       
        if theEvent.keyCode == 36 && theEvent.modifierFlags.intersection(
            .deviceIndependentFlagsMask) == .command {
            Swift.print("command-return pressed")
            self.doCommand(by: #selector(QuietViewController.doSaveEntry))
            return
        }
        super.keyDown(with: theEvent)
        
    }
    
}
