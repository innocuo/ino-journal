import Cocoa
import Carbon

class QuietTextField: NSTextView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    
    override func keyDown(with event: NSEvent) {
        
        //let    modifiers :uint32 = GetCurrentKeyModifiers();
        //Swift.print(modifiers)
       
        if event.keyCode == 36 && event.modifierFlags.intersection(
            .deviceIndependentFlagsMask) == .command {
            Swift.print("command-return pressed")
            self.doCommand(by: #selector(QuietViewController.doSaveEntry))
            return
        }
        super.keyDown(with: event)
        
    }
    
}
